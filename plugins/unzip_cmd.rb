#!/usr/bin/env ruby
require './system_cmd'

class UnzipCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "unzip"
  end
end
