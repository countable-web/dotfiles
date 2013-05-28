
var sys = require("sys");
var p = require("path");
var fs = require("fs");
var spawn = require("child_process").spawn;
var exec = require("child_process").exec;
var fileExtensionPattern;
var program, port;
// A program name which is "impossible" for anyone to choose, which represents no program.
var NO_PROGRAM = "__none__.coffee";

exports.run = run;

function run (args) {
  var arg, next, watch, extensions, executor;
  while (arg = args.shift()) {
    if (arg === "--help" || arg === "-h" || arg === "-?") {
      return help();
    } else if (arg === "--watch" || arg === "-w") {
      watch = args.shift();
    } else if (arg === "--port" || arg === "-p") {
      port = args.shift();
    } else if (arg === "--extensions" || arg === "-e") {
      extensions = args.shift();
    } else if (arg === "--exec" || arg === "-x") {
      executor = args.shift();
    } else if (arg.indexOf("-") && !args.length) {
      // Assume last arg is the program
      program = arg;
    }
  }
  if (!program) {
    //return help();
    var pwdFiles = fs.readdirSync('.');
    var autoRunFiles = ["app.js", "app.coffee", "manage.py"]
    for (var i = 0; i < autoRunFiles.length; i++) {
      if (pwdFiles.indexOf(autoRunFiles[i]) > -1) program=autoRunFiles[i];
    }
    if (!program) {
      program = NO_PROGRAM;
    }

  }
  if (!watch) {
    watch = ".";
  }

  var programExt = program.match(/.*\.(.*)/);
  programExt = programExt && programExt[1];

  if (!extensions) {
    // If no extensions passed try to guess from the program
    extensions = "node|js|styl|eco|coffee|jade";
    if (programExt && extensions.indexOf(programExt) == -1)
      extensions += "|" + programExt;
  }
  fileExtensionPattern = new RegExp(".*\.(" + extensions + ")$");
  
  if (!executor) {
    if (programExt === "coffee") {
      executor = "coffee";
    } else if (programExt === "py") {
      executor = "python";
    } else if (programExt === "js") {
      executor = "node";
    } else {
      throw "Extension `" + programExt + "` not supported.";
    }
  }
  
  sys.puts("")
  sys.debug("Running node-supervisor with");
  sys.debug("  program '" + program + "'");
  sys.debug("  --watch '" + watch + "'");
  sys.debug("  --extensions '" + extensions + "'");
  sys.debug("  --exec '" + executor + "'");
  sys.puts("")
  
  // if we have a program, then run it, and restart when it crashes.
  // if we have a watch folder, then watch the folder for changes and restart the prog

  if (program !== NO_PROGRAM) startProgram(program, executor);
  var watchItems = watch.split(',');
  watchItems.forEach(function (watchItem) {
    if (!watchItem.match(/^\/.*/)) { // watch is not an absolute path
      // convert watch item to absolute path
      watchItem = process.cwd() + '/' + watchItem;
    }
    sys.debug("Watching directory '" + watchItem + "' for changes.");
    findAllWatchFiles(watchItem, watchGivenFile);
  });
};

function print (m, n) { sys.print(m+(!n?"\n":"")); return print }

function help () {
  print
    ("")
    ("Node Supervisor is used to restart programs when they crash.")
    ("It can also be used to restart programs when a *.js file changes.")
    ("")
    ("Usage:")
    ("  supervisor [options] <program>")
    ("")
    ("Required:")
    ("  <program>")
    ("    The program to run.")
    ("")
    ("Options:")
    ("  -w|--watch <watchItems>")
    ("    A comma-delimited list of folders or js files to watch for changes.")
    ("    When a change to a js file occurs, reload the program")
    ("    Default is '.'")
    ("")
    ("  -e|--extensions <extensions>")
    ("    Specific file extensions to watch in addition to defaults.")
    ("    Used when --watch option includes folders")
    ("    Default is 'node|js'")
    ("")
    ("  -x|--exec <executable>")
    ("    The executable that runs the specified program.")
    ("    Default is 'node'")
    ("")
    ("  -h|--help|-?")
    ("    Display these usage instructions.")
    ("")
    ("Examples:")
    ("  supervisor myapp.js")
    ("  supervisor myapp.coffee")
    ("  supervisor -w scripts -e myext -x myrunner myapp")
    ("  supervisor -w lib -w server.js -w config.js server.js")
    ("")
}

function startProgram (prog, exec) {
  var cl_args;
  if (prog == 'manage.py') {
    program = NO_PROGRAM
    // special case for Django program.
    cl_args = [prog, 'runserver', '0.0.0.0:' + (port || 8000)];
  } else {
    cl_args = [prog];
  }
  sys.debug("Starting child process with '" + exec + " " + cl_args.join(' ') + "'");
  var child = exports.child = spawn(exec, cl_args);
  child.stdout.addListener("data", function (chunk) { chunk && sys.print(chunk) });
  child.stderr.addListener("data", function (chunk) { chunk && sys.debug(chunk) });
  child.addListener("exit", function () { startProgram(prog, exec) });
}

var timer = null, counter = -1, mtime = null;

function getExtension(filename) {
  var programExt = filename.match(/.*\.([^\.]*)$/);
  return programExt && programExt[1];
}

function stopCrashing () {
  if (counter > 3) throw new Error("Crashing too much, shutting down");
  else counter = -1;
}

function watchGivenFile (watch) {
  fs.watchFile(watch, function crash (oldStat, newStat) {
    // we only care about modification time, not access time.
    if (
      newStat.mtime.getTime() === oldStat.mtime.getTime()
    ) return;
  
    if (counter === -1) {
      timer = setTimeout(stopCrashing, 400);
    }
    counter ++;

    var child = exports.child;
    sys.debug("detected change at "+watch);
    var extension = getExtension(watch);
    if ("coffee" === extension) {
      sys.debug("compiling with coffeescript.");
      exec("coffee -c "+watch,function(err, stderr, stdout) {
            if (err) sys.debug(err);
            if (stderr) sys.debug(stderr);
            if (stdout) sys.debug(stdout);
      });
    } else if (extension === "styl") {
      sys.debug('compiling with stylus.');
      exec("stylus "+watch,function(err, stderr, stdout) {
            if (err) sys.debug(err);
            if (stderr) sys.debug(stderr);
            if (stdout) sys.debug(stdout);
      });
    } else if (extension === "eco") {
      sys.debug('compiling with eco.');
      exec("eco -o "+p.dirname(watch)+" "+watch,function(err, stderr, stdout) {
            if (err) sys.debug(err);
            if (stderr) sys.debug(stderr);
            if (stdout) sys.debug(stdout);
      });
    } else if (extension === "jade" && watch.indexOf("client") > -1) {
      sys.debug('compiling with clientjade wrapper.');
      exec("clientjade.py " + p.dirname(watch),function(err, stderr, stdout) {
            if (err) sys.debug(err);
            if (stderr) sys.debug(stderr);
            if (stdout) sys.debug(stdout);
      });

    } else {
      if (program !== NO_PROGRAM) process.kill(child.pid);
    }
  });
}

var findAllWatchFiles = function(path, callback) {
  fs.stat(path, function(err, stats){
    if (err) {
      sys.error('Error retrieving stats for file: ' + path);
    } else {
      if (stats.isDirectory()) {
        fs.readdir(path, function(err, fileNames) {
          if(err) {
            sys.puts('Error reading path: ' + path);
          }
          else {
            fileNames.forEach(function (fileName) {
              findAllWatchFiles(path + '/' + fileName, callback);
            });
          }
        });
      } else {

        if (path.match(fileExtensionPattern)) {
          callback(p.normalize(path));
        }
      }
    }
  });
}
