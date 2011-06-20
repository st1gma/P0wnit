#!/usr/bin/env ruby
require './system_cmd'

class FlsCmd < SystemCmd
  def initialize(filename, *opts)
    @cmd = "fls"
    super
  end
end
