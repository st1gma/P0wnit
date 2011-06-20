#!/usr/bin/env ruby
require './system_cmd'

class GunzipCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "gunzip"
  end
end
