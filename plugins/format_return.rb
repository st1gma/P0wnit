#!/usr/bin/env ruby

module FormatReturn
  def format_ret_val(str, format)
    ret = str
    if format == "html"
      ret = "<code>#{ret}</code>"
    elsif format == "plain"
      ret = ret.gsub("<hr />", "\n\n########################################################################\n\n")
      ret = ret.gsub("<br />", "\n").gsub(/<.+?>/, "")
    end
    
    ret
  end
end
