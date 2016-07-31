require 'rest-client'

class WollokQueryHook < WollokHook
  def transform_response(response)
    if response['consoleOutput'].present?
      [response['consoleOutput'], :passed]
    elsif response['runtimeError'].present?
      [response['runtimeError']['message'], :failed]
    elsif response['compilation'].present?
      [extract_compilation_errors(response), :failed]
    end
  end

  def program_type
    'wpgm'
  end

  def compile_program_after_directives(r)
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

object mumukiConsole {
  var inCookie = false

  method enterCookie() { inCookie = true }
  method exitCookie() { inCookie = false }

  method println(anObject) {
    if (!inCookie) {
       console.println(anObject)
    }
  }
}

program mumuki {
  mumukiConsole.enterCookie()
  #{build_state(r.cookie)}
  mumukiConsole.exitCookie()

  mumukiPrettyPrinter.prettyPrint(#{r.query})
}
WLK
  end

  def build_state(cookie)
    (cookie||[]).map { |statement| "try { #{statement} } catch e : Exception {  }" }.join("\n")
  end
end