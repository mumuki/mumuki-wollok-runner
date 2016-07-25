require 'rest-client'

class WollokQueryHook < WollokHook
  def transform_response(response)
    if response['consoleOutput'].present?
      [response['consoleOutput'] || '', :passed]
    elsif response['runtimeError'].present?
      [response['runtimeError']['message'], :failed]
    end
  end

  def program_type
    'wpgm'
  end

  def compile_program(r)
<<WLK
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
end