#!/usr/local/bin/coffee

args = process.argv
if args[0] is 'coffee'
  command = args[0..1]
  args = args[2..]
else
  command = args[0]
  args = args[1..]
  
usage = """
        usage: #{command} [-o build/] file1.html file2.html ...
        """

coffee = require 'coffee-script'
fs = require 'fs'
$ = require 'jquery'

output_dir = 'build'
flag = null
files = []
for arg in args
  if arg[0] is '-'
    flag = arg
  else if flag?
    switch flag
      when '-o'
        output_dir = arg
    flag = null
  else
    files.push arg
    
unless files.length
  console.log usage

for file in files
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