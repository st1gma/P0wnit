#!/usr/bin/env ruby
require './system_cmd'

class P7zipCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "p7zip -d"
  end

  def run
    fileparts = filename.split("/")
     ft_out = `file #{filename}`
     fe = ''
     if ft_out =~ /gzip compressed data/
       fe = "gz"
     end

    cmd_str = "p7zip -d #{filename}_dir/#{fileparts[-1]}.#{fe}"
    ret = "#{cmd_str}<br />"
    curdir = Dir.pwd
    if !Dir.exists?("#{filename}_dir")
      Dir.chdir("/opt/apps/p0wnit/downloads/")
      FileUtils.mkdir("#{filename}_dir")
      
      FileUtils.cp("#{filename}", "#{filename}_dir/")

      Dir.chdir("#{filename}_dir")

      #fileparts = filename.split("/")

      FileUtils.mv(fileparts[-1], "#{fileparts[-1]}.#{fe}")

      #system("mv /opt/apps/p0wnit/downloads/#{filename}_dir/#{filename} /opt/apps/p0wnit/downloads/#{filename}_dir/#{filename}.#{fe}")

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
