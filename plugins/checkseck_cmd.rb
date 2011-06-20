#!/usr/bin/env ruby
require './system_cmd'

class ChecksecCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "#{File.dirname($0)}/utils/checksec.sh --file"
    puts @cmd
  end

  def run
    ret = cmd_str + "<br /><br />"
    ret += `#{cmd_str}`
    ret.gsub!(/[^0-9A-Za-z\s<>\/\\\.]/, " -- ")
    ret.gsub!(/[0-9]{0,2}m/, "")
    ret.gsub("\n", "<br />").gsub("\r", "")
  end
end
