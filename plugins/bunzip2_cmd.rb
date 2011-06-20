#!/usr/bin/env ruby
require './system_cmd'

class Bunzip2Cmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "bunzip2"
  end
end
