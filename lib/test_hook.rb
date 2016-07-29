class WollokTestHook < WollokHook

  def transform_response(result)
    if result['tests'].present?
      [result['tests'].map { |it| transform_test_result(it) }]
    elsif result['runtimeErrors'].present?
      [result['runtimeErrors'].to_s, :failed]
    elsif result['compilation']['issues'].present?
      [result['compilation']['issues'].map { |it| transform_compilation_error(it) }.join("\n"), :errored]
    elsif result['consoleOutput'].present?
      [result['consoleOutput'] || '', :failed]
    else
      [result.to_s, :errored]
    end
  end

  def transform_compilation_error(issue)
    "#{issue['severity']}: #{issue['message']}"
  end

  def transform_test_result(result)
    [result['name'], result['state'] == 'passed' ? :passed : :failed, result['error'].try{|i|i['stackTrace']}]
  end

  def program_type
    'wtest'
  end

  def compile_program(r)
    Interpolator.new.try_interpolate(
        :test,
        test: r.test,
        content: r.content,
        extra: r.extra) do
      <<WLK
#{r.extra}
#{r.content}
#{r.test}
WLK
    end
  end

end