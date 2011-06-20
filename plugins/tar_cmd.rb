#!/usr/bin/env ruby
require './system_cmd'

class TarCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "tar -xvf"
  end

  def run
    cmd_str = "tar -xvf #{filename}"
    ret = "#{cmd_str}<br />"
    curdir = Dir.pwd
    if !Dir.exists?("#{filename}_dir")
      Dir.chdir("/opt/apps/p0wnit/downloads/")
      FileUtils.mkdir("#{filename}_dir")
      FileUtils.cp("#{filename}", "#{filename}_dir/")

      Dir.chdir("#{filename}_dir")

      ret += `#{cmd_str}`

      Dir.chdir("../")
 
      ents = Dir.entries("#{filename}_dir")
      Dir.chdir(curdir)
      ret += "<b>Files: </b>"
      ents.each do |file|
        if file !~ /^.+$/
          ret += "#{file}<br />"
        end
      end

      Dir.chdir(curdir)
    else
      Dir.chdir("/opt/apps/p0wnit/downloads/")
      ents = Dir.entries("#{filename}_dir")
      Dir.chdir(curdir)
      ret = "<b>Already untarred</b>"
      
      ents.each do |file|
        if file !~ /^.+$/
          ret += "#{file}<br />"
        end
      end
    end
    ret
  end
end
