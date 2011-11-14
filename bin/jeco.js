(function() {
  var content, eco, fs, jeco, name, path;
  eco = require('eco');
  fs = require('fs');
  path = require('path');
  name = path.basename(process.argv[2], '.jeco');
  jeco = function(path) {
    var content;
    content = eco.precompile(fs.readFileSync(path, 'utf8'));
    return "@ecoTemplates." + name + " = module.exports = function(values){\n  var $  = jQuery, result = $();\n  values = $.makeArray(values);\n\n  for(var i=0; i < values.length; i++) {\n    var value = values[i];\n    var elem  = $((" + content + ")(value));\n    elem.data('item', value);\n    $.merge(result, elem);\n  }\n  return result;\n};";
  };
  content = jeco(process.argv[2].toString());
  fs.writeFile(process.argv[2].replace('jeco', 'js'), content);
}).call(this);
