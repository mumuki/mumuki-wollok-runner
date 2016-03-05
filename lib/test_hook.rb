class TestHook < Mumukit::Templates::FileHook
  mashup
  isolated true

  def command_line(filename)
    "#{wollok_command} #{filename} 2>&1"
  end

  def post_process_file(file, result, status)
    if result.include? 'wollok.lang.Exception'
      [result, :failed]
    else
      super
    end
  end

  def tempfile_extension
    '.wtest'
  end
end