#!/usr/bin/env ruby
require './handle_opts'

class SystemCmd
  include HandleOpts
  
  attr_accessor :opts, :pipe, :order, :filename, :format
  attr_writer :cmd_str
  attr_reader :cmd
  
  def initialize(filename, *opts)
    @filename = filename
    @format = "plain"
    @pipe = false
    @opts = opts
  end
  
  def cmd_str
    #puts "OPTS " + @opts.inspect
    if @pipe == true
      return " | " + @cmd + " " + opts_to_str(@opts) + " " + @filename
    else
      parsed_ops = opts_to_str(@opts)
      return @cmd.to_s + " " + parsed_ops[:before_fn].to_s  + " " + @filename.to_s + " " + parsed_ops[:after_fn].to_s
    end
  end
  
  def run
    if @cmd_str.nil?
       @cmd_str = cmd_str
    end
    ret = @cmd_str + "<br /><br />"
    if File.exists?("/opt/apps/p0wnit/cache/#{@cmd_str.gsub(/[^A-Za-z0-9\-\.]/, '--')}")
      ret += "<b>Cached Read</b><br />"
      ret += File.read("/opt/apps/p0wnit/cache/#{@cmd_str.gsub(/[^A-Za-z0-9\-\.]/, '--')}")
    else
      cmd_ret = `#{@cmd_str} 2>&1`
      ret += cmd_ret
      File.open("/opt/apps/p0wnit/cache/#{@cmd_str.gsub(/[^A-Za-z0-9\-\.]/, '--')}", "w") do |cachefile|
        cachefile.puts cmd_ret
      end
    end
    ret.gsub("\n", "<br />").gsub("\r", "")
  end
  
  def add_opt(cmd_opt)
    if @opts == nil
      @opts = [cmd_opt]
    else
      @opts.push cmd_opt
    end   
  end
  
  def <=>(other_obj)
    self.order <=> other_obj.order
  end
end
