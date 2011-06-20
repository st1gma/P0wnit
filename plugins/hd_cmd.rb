#!/usr/bin/env ruby
require './system_cmd'

class HdCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "hd"
  end
  
  def get_chars(str)
    ret = ""
    lines = str.split("<br />")
   
    i = 0
    cmd_str = "hd #{filename}" 
    lines.each do |line|
      #if i == 0
      #  cmd_str = line
      #else
        parts = line.split("|")
        ret += parts[1].to_s.gsub("..", " ").gsub(".", "")
      # end
    end
    cmd_str + "<br />" + ret.gsub(/\s+/, "<br />")
  end
end
