#!/usr/bin/env ruby

module HandleOpts
  class CmdOpt
    attr_accessor :switch, :val, :order, :pipe_to_cmd, :opts
    
    def initialize(val, switch="", order=1, pipe_to_cmd=false, *opts)
      @val = val
      @switch = switch
      @order = order
      @pipe_to_cmd = pipe_to_cmd
      @opts = opts
    end
    
    def <=>(other_obj)
      self.order <=> other_obj.order
    end
  end
  
  def opts_to_str(opts)
    ret_opts = {:before_fn => "", :after_fn => ""}
    if opts != nil
      if opts.is_a?(Array)
        opts.sort!
        
        opts.each do |opt|
          if opt.pipe_to_cmd == false
            #puts "NOT PIPING"
            ret_opts[:before_fn] += " #{opt.switch} #{opt.val} "
          else
            ret_opts[:after_fn] += " | " + opt.val.cmd_str
          end
        end
      elsif opts.is_a?(CmdOpt)
        #puts "IS A CmdOpt"
        ret_opts[:before_fn] += " #{opts.switch} #{opts.val} "
      end
    end
    ret_opts
  end
  
  def parse_opts(opts_str)
    
  end
end
