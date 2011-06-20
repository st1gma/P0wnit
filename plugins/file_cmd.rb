#!/usr/bin/env ruby
require './system_cmd'

class FileCmd < SystemCmd
  def initialize(filename, *opts)
    super
    @cmd = "file"
  end
end
