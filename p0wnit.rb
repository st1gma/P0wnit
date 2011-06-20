require 'rubygems'
require 'time'
require 'fileutils'
require './plugins/format_return'
require './plugins/handle_opts'

# encode: utf-8


class P0wnit
  include FormatReturn
  include HandleOpts
  
  Dir["plugins/*.rb"].each do |file|
    FileUtils.chdir("plugins")
    #puts File.basename(file).gsub(/\.rb$/, "").strip
    require "./" + File.basename(file).gsub(/\.rb$/, "").strip
    #puts File.basename(file).gsub(/\.rb$/, "").strip.gsub(/(^|_)(.)/) { $2.upcase }
    #modName = File.basename(file).gsub(/\.rb$/, '').strip.gsub(/(^|_)(.)/) { $2.upcase }
    #puts modName
    #eval("include #{modName}")
    FileUtils.chdir("../")
  end
  
  attr_accessor :format, :filepath, :parentfile, :child_dir, :filetype
  
  def initialize(filepath)
    @filepath = filepath
    @format = "plain"
  end

  def self.run_cmd(cmd)
    sys_cmd = SystemCmd.new(@filepath)
    sys_cmd.format = "html"
    sys_cmd.cmd_str = cmd
    puts sys_cmd.inspect
    sys_cmd.run
  end
  
  def format_output(str)
    format_ret_val(str, @format)
  end
  
  def set_format(cmd_obj)
    cmd_obj.format = @format
    cmd_obj
  end
  
  def method_missing(m, *args, &block)
    class_name = m.id2name.sub(/^run_/, "").capitalize + "Cmd"
    obj = eval("#{class_name}.new(@filepath)")
    obj
  end

  def defaultExtraFiletype
     ret = ""
     if @filetype == "ELF executable"
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>Executable Type:</h2><br />")
      ret += format_output("ELF executable<br />")
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>Checksec:</h2><br />")
      #puts @filepath
      #checksec_cmd = set_format(ChecksecCmd.new(@filepath))

      #ret += checksec_cmd.run
    elsif @filetype == "Raw Drive Image"
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>File Type:</h2><br />")
      ret += format_output("Raw Drive Image<br />")
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>fls:</h2><br />")
      #puts @filepath
      fls_cmd = set_format(FlsCmd.new(@filepath))

      ret += fls_cmd.run

      #ret += format_output("<br /><hr /><br />")
      #ret += format_output("<h2>Mount -o:</h2><br />")
      ##puts @filepath
      #mount_cmd = set_format(MountCmd.new(@filepath))

      #ret += mount_cmd.run
    elsif @filetype == "JPEG Image"
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>File Type:</h2><br />")
      ret += format_output("JPEG Image<br />")
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>stegdetect:</h2><br />")
      #puts @filepath
      stegdetect_cmd = set_format(StegdetectCmd.new(@filepath))

      ret += stegdetect_cmd.run

    elsif @filetype == "ARCHIVE"
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>File Type:</h2><br />")
      ret += format_output("Compressed File<br />")
      ret += format_output("<br /><hr /><br />")
      ret += format_output("<h2>p7zip -d:</h2><br />")
      p7zip_cmd = set_format(P7zipCmd.new(@filepath))
       
      ret += p7zip_cmd.run
    elsif @filetype == "DIRECTORY"
      ret += format_output("<br /><hr /><br />")
      Dir.foreach(@filepath) do |filename|
         ret += filename + "<br />"
      end
    end
    ret
  end
  
  
  def defaultCmds
    ret = "<pre>"
    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>File:</h2><br />")
    #puts @filepath
    file_cmd = set_format(FileCmd.new(@filepath))
   
    ftype = file_cmd.run
    ret += ftype

    if ftype =~ /executable/i && ftype =~ /ELF/
	@filetype = "ELF executable"
    elsif ftype =~ /gzip compressed data/
   	@filetype = "ARCHIVE"
    elsif ftype =~ /tar archive/
	@filetype = "TAR"
    elsif ftype =~ /executable/i && ftype =~ /Windows/
	@filetype = "Windows executable"
    elsif ftype =~ /x86 boot sector/
	@filetype = "Raw Drive Image"
    elsif ftype =~ /JPEG/
        @filetype = "JPEG Image"
    elsif ftype =~ /data/ && @filepath =~ /tar$/
        @filetype = "ARCHIVE"
    elsif ftype =~ /directory/
        @filetype = "DIRECTORY"
    end

    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>Filetype: #{@filetype}</h2><br />")
    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>Strings for key:</h2>")
    ret += format_output('<a href="/p0wnit/runcmd?filepath=' + @filepath  + '&cmd=strings+-3+FILENAME">Full "strings -3" output</a><br />')
    grep_cmd_op = CmdOpt.new("10", '-C', 1, false)
    grep_cmd_find_op = CmdOpt.new("key", "", 100)
    grep_cmd = GrepCmd.new("", grep_cmd_op, grep_cmd_find_op)
    pipe_grep_cmd_op = CmdOpt.new(grep_cmd, "", 100, true)
    strings_cmd_op = CmdOpt.new("", "-3")
    strings_cmd = set_format(StringsCmd.new(@filepath, strings_cmd_op, pipe_grep_cmd_op))
    ret += strings_cmd.run
    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>Strings for key (Unicode):</h2>")
    ret += format_output('<a href="/p0wnit/runcmd?filepath=' + @filepath  + '&cmd=strings+-3+-e+l+FILENAME">Full "strings -3 -e l" output</a><br />')
    strings_cmd_uni_op = CmdOpt.new("l", "-e")
    strings_cmd.add_opt(strings_cmd_uni_op)
    ret += strings_cmd.run
    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>HexDump for k.e.y:</h2>")
    ret += format_output('<a href="/p0wnit/runcmd?filepath=' + @filepath  + '&cmd=hd+FILENAME">Full "hd" output</a><br />')
    grep_cmd_op = CmdOpt.new("10", '-C', 1, false)
    grep_cmd_find_op = CmdOpt.new("k.e.y", "", 100)
    grep_cmd = GrepCmd.new("", grep_cmd_op, grep_cmd_find_op)
    pipe_grep_cmd_op = CmdOpt.new(grep_cmd, "", 100, true)
    hd_cmd = HdCmd.new(@filepath, pipe_grep_cmd_op)
    ret += hd_cmd.run
    ret += format_output("<br /><hr /><br />")
    ret += format_output("<h2>HexDump Only Letters:</h2><br />")
    ret += format_output('<a href="/p0wnit/hd_str_only?filepath=' + @filepath  + '">Full "hd" strings only output</a><br />')
    ret += format_output(hd_cmd.get_chars(hd_cmd.run))
    
    ret += defaultExtraFiletype

    ret += "</pre>"
    ret
  end
end

if __FILE__ == $0
  server = false
  if ARGV[0] == "-S"
    ARGV = []
    server = true
  else
    filepath = ARGV[0]
  end

  if server
    require 'sinatra'

    get '/' do
      out = "<h1>Files On Server</h1>"
      Dir.foreach("/opt/apps/p0wnit/downloads") do |filename|
        if filename !~ /^\./
            out += filename + ': <a href="/p0wnit/localfile?filepath=/opt/apps/p0wnit/downloads/' + filename + '">Run Commands</a>'
            if filename !~ /dir$/
              out += ' | <a href="download?file=/opt/apps/p0wnit/downloads/' + filename + '">Download File</a>'
            end
            out += '</br>'
        end
                
      end 
      out += '<h1>Upload a file</h1>
        <form action="/p0wnit/upload" method="post" enctype="multipart/form-data">
          <input type="file" name="file">
          <input type="submit" value="upload">
        </form>

        <h1>Use a Local file</h1>
        <form action="/p0wnit/localfile" method="get" >
          File Path on Server: <input type="text" name="filepath">
          <input type="submit" value="Analyze File">
        </form>'
      out  
    end

    get '/download' do 
      file = params[:file]

      send_file(file)

    end

    post '/upload' do
      unless params[:file] &&
           (tmpfile = params[:file][:tempfile]) &&
           (name = params[:file][:filename])
        @error = "No file selected"
        return haml(:upload)
      end
      directory = "downloads"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(tmpfile.read) }
  
      #filepath = dirName + "/" + name
      #puts filepath
    
      pwn = P0wnit.new(path)

      pwn.format = "html"
    
      ret = pwn.defaultCmds
     
      puts ret
  
      ret
    end
  
    get '/localfile' do
      path = params[:filepath]
      puts params.inspect
      puts path
      pwn = P0wnit.new(path)
      pwn.format = "html"
      ret = pwn.defaultCmds
      puts ret
   
      ret
    end

    get '/hd_str_only' do
      path = params[:filepath]
      pwn = P0wnit.new(path)
      hd = pwn.hd
      ret = '<h1>HD Strings Only</h1>'
      ret += hd.get_chars(hd.run).gsub("\n", "<br />").gsub("\r", "<br />")
      '<pre>' + ret + '</pre>'
    end

    get '/runcmd' do
      path = params[:filepath]
      cmd = params[:cmd].gsub("FILENAME", path)
      ret = '<pre>'
      ret += P0wnit.run_cmd(cmd)
      ret += '</pre>'
      ret
    end
  else
    pwn = P0wnit.new(filepath)
    puts pwn.defaultCmds
  end
end
