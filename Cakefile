fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'
$             = require 'jquery'
coffee        = require 'coffee-script'

# ANSI Terminal Colors
bold = '\033[0;1m'
green = '\033[0;32m'
reset = '\033[0m'
red = '\033[0;31m'

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
    
  output_dir = 'build'
  flag = null
  file = 'index.html'

  fs.readFile file, 'utf8', (err, data) ->
    throw err if err
    fs.rmdir output_dir, ->
      fs.mkdir output_dir, ->
        for el in $(data).find('[filename]')
          filename = $(el).attr('filename')
          if filename.length >= 7 and filename[-7..] is '.coffee'
            jsfilename = filename[0..-7] + 'js'
            fs.writeFile output_dir+'/'+jsfilename, coffee.compile($(el).html()), 'utf8'
          fs.writeFile output_dir+'/'+filename, $(el).html(), 'utf8'

task 'build', ->
  build -> log ":)", green