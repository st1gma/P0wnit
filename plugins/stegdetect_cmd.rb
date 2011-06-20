#!/usr/bin/env ruby
require './system_cmd'

class StegdetectCmd < SystemCmd
  def initialize(filename, *opts)
    @cmd = "stegdetect"
    super
  end
end
