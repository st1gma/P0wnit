#!/usr/bin/env ruby
require './system_cmd'

class GrepCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "grep"
  end
end
