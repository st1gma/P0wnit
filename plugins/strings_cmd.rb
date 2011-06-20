#!/usr/bin/env ruby
require './system_cmd'

class StringsCmd < SystemCmd
  def initialize(filename, *opts)
    @cmd = "strings"
    super
  end
end
