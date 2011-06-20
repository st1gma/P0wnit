#!/usr/bin/env ruby
require './system_cmd'

class MountCmd < SystemCmd
  def initialize(filename, *opts)
    @cmd = "mkdir /mnt/[filename];mount -o loop /mnt/[filename]"
    super
  end

  def run
  
  end
end
