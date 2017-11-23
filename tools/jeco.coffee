#!usr/local/bin/coffee

eco = require 'eco'
fs = require 'fs'

jeco = (path) ->
  content = eco.precompile fs.readFileSync path, 'utf8'
  """
  module.exports = function(values){
    var $  = jQuery, result = $();
    values = $.makeArray(values);

    for(var i=0; i < values.length; i++) {
      var value = values[i];
      var elem  = $((#{content})(value));
      elem.data('item', value);
      $.merge(result, elem);
    }
    return result;
  };
  """

content = jeco process.argv[2].toString()
fs.writeFile process.argv[2].replace('jeco','js'), content

