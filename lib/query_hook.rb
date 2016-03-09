class QueryHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.wpgm'
  end

  def compile_file_content(r)
    compilation = <<WLK
#{r.extra}
    #{r.content}
program mumuki {
  #{build_state(r.cookie)}
  console.println('=> ' + (#{r.query}).toString())
}
WLK
  end

  def build_state(cookie)
    (cookie||[]).map { |statement| "try { #{statement} } catch e : Exception {  }" }.join("\n")
  end

  def command_line(filename)
    "#{wollok_command} #{filename} 2>&1"
  end

  def post_process_file(file, result, status)
    [remove_warnings(result), status]
  end

  def remove_warnings(result)
    result.
        split("\n").
        reject { |it| it.start_with?('Warning: ') || it.include?('WARNING Unused variable') }.
        map { |it| "#{it}\n" }.
        join
  end
end