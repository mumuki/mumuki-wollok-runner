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
object mumukiPrettyPrinter {
  method prettyPrint(anObject) {
    if (anObject != null && anObject != void)
      console.println('=> '  + anObject.toString())
    else
      console.println('=>')
  }

}

program mumuki {
  #{build_state(r.cookie)}
  mumukiPrettyPrinter.prettyPrint(#{r.query})
}
WLK
  end

  def build_state(cookie)
    (cookie||[]).map { |statement| "try { #{statement} } catch e : Exception {  }" }.join("\n")
  end
end