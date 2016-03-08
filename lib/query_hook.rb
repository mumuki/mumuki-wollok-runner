class QueryHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.wpgm'
  end

  def compile_file_content(r)
    "#{r.extra}\n#{r.content}\nprogram mumuki {  #{build_state(r.cookie)}  console.println('=> ' + (#{r.query}).toString()) }"
  end

  def build_state(cookie)
    cookie.map { |statement| "try { #{statement} } catch(Exception e) {  }" }.join("\n")
  end

  def command_line(filename)
    "#{wollok_command} #{filename} 2>&1"
  end
end