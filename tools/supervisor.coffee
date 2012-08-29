console.log 'starting'
run = (args) ->
  console.log 'running'
  watch = undefined
  extensions = undefined
  executor = undefined
  while arg = args.shift()
    if arg is "--help" or arg is "-h" or arg is "-?"
      return help()
    else if arg is "--watch" or arg is "-w"
      watch = args.shift()
    else if arg is "--port" or arg is "-p"
      port = args.shift()
    else if arg is "--extensions" or arg is "-e"
      extensions = args.shift()
    else if arg is "--exec" or arg is "-x"
      executor = args.shift()
    else program = arg  if arg.indexOf("-") and not args.length
  program = NO_PROGRAM  unless program
  watch = "."  unless watch
  programExt = program.match(/.*\.(.*)/)
  programExt = programExt and programExt[1]
  extensions = "node|js|styl|eco|coffee"  unless extensions
  fileExtensionPattern = new RegExp(".*.(" + extensions + ")$")
  unless executor
    if programExt is "coffee"
      executor = "coffee"
    else if programExt is "py"
      executor = "python"
    else if programExt is "js"
      executor = "node"
    else
      throw "Extension `" + programExt + "` not supported."
  sys.puts ""
  sys.debug "Running node-supervisor with"
  sys.debug "  program '" + program + "'"
  sys.debug "  --watch '" + watch + "'"
  sys.debug "  --extensions '" + extensions + "'"
  sys.debug "  --exec '" + executor + "'"
  sys.puts ""
  pwdFiles = fs.readdirSync(".")
  console.log pwdFiles
  autoRunFiles = [ "app.coffee", "app.js", "manage.py" ]
  for file in pwdFiles
    if file in autoRunFiles and program is NO_PROGRAM
      program = file
      console.log "found and running: " + file
  startProgram program, executor  if program isnt NO_PROGRAM
  watchItems = watch.split(",")
  watchItems.forEach (watchItem) ->
    watchItem = process.cwd() + "/" + watchItem  unless watchItem.match(/^\/.*/)
    sys.debug "Watching directory '" + watchItem + "' for changes."
    findAllWatchFiles watchItem, watchGivenFile
print = (m, n) ->
  sys.print m + (if not n then "\n" else "")
  print
help = ->
  print("")("Node Supervisor is used to restart programs when they crash.")("It can also be used to restart programs when a *.js file changes.")("")("Usage:")("  supervisor [options] <program>")("")("Required:")("  <program>")("    The program to run.")("")("Options:")("  -w|--watch <watchItems>")("    A comma-delimited list of folders or js files to watch for changes.")("    When a change to a js file occurs, reload the program")("    Default is '.'")("")("  -e|--extensions <extensions>")("    Specific file extensions to watch in addition to defaults.")("    Used when --watch option includes folders")("    Default is 'node|js'")("")("  -x|--exec <executable>")("    The executable that runs the specified program.")("    Default is 'node'")("")("  -h|--help|-?")("    Display these usage instructions.")("")("Examples:")("  supervisor myapp.js")("  supervisor myapp.coffee")("  supervisor -w scripts -e myext -x myrunner myapp")("  supervisor -w lib -w server.js -w config.js server.js") ""

startProgram = (prog, exec) ->
  cl_args = undefined
  if prog is "manage.py"
    program = NO_PROGRAM
    cl_args = [ prog, "runserver", "0.0.0.0:" + (port or 8000) ]
  else
    cl_args = [ prog ]
  sys.debug "Starting child process with '" + exec + " " + cl_args.join(" ") + "'"
  child = exports.child = spawn(exec, cl_args)
  child.stdout.addListener "data", (chunk) ->
    chunk and sys.print(chunk)

  child.stderr.addListener "data", (chunk) ->
    chunk and sys.debug(chunk)

  child.addListener "exit", ->
    startProgram prog, exec
getExtension = (filename) ->
  programExt = filename.match(/.*\.([^\.]*)$/)
  programExt and programExt[1]
stopCrashing = ->
  if counter > 3
    throw new Error("Crashing too much, shutting down")
  else
    counter = -1
watchGivenFile = (watch) ->
  fs.watchFile watch, crash = (oldStat, newStat) ->
    return  if newStat.mtime.getTime() is oldStat.mtime.getTime()
    timer = setTimeout(stopCrashing, 400)  if counter is -1
    counter++
    child = exports.child
    sys.debug "detected change at " + watch
    extension = getExtension(watch)
    if "coffee" is extension
      sys.debug "compiling with coffeescript."
      exec "coffee -c " + watch, (err, stderr, stdout) ->
        sys.debug err  if err
        sys.debug stderr  if stderr
        sys.debug stdout  if stdout
    else if extension is "styl"
      sys.debug "compiling with stylus."
      exec "stylus " + watch, (err, stderr, stdout) ->
        sys.debug err  if err
        sys.debug stderr  if stderr
        sys.debug stdout  if stdout
    else if extension is "eco"
      sys.debug "compiling with eco."
      exec "eco -o " + p.dirname(watch) + " " + watch, (err, stderr, stdout) ->
        sys.debug err  if err
        sys.debug stderr  if stderr
        sys.debug stdout  if stdout
    else
      process.kill child.pid  if program isnt NO_PROGRAM
sys = require("sys")
p = require("path")
fs = require("fs")
spawn = require("child_process").spawn
exec = require("child_process").exec
fileExtensionPattern = undefined
program = undefined
port = undefined
NO_PROGRAM = "__none__.coffee"
exports.run = run
timer = null
counter = -1
mtime = null
findAllWatchFiles = (path, callback) ->
  fs.stat path, (err, stats) ->
    if err
      sys.error "Error retrieving stats for file: " + path
    else
      if stats.isDirectory()
        fs.readdir path, (err, fileNames) ->
          if err
            sys.puts "Error reading path: " + path
          else
            fileNames.forEach (fileName) ->
              findAllWatchFiles path + "/" + fileName, callback
      else
        callback p.normalize(path)  if path.match(fileExtensionPattern)
