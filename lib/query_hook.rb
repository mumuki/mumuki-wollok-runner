require 'rest-client'

class WollokCookie < Mumukit::Cookie
  private

  def statements_code
    statements.map { |statement| "try { #{statement} } catch e : Exception {  }" }.join("\n")
  end

  def stdout_separator_code
    "console.println(\"#{stdout_separator}\")"
  end
end

class WollokQueryHook < WollokHook
  stateful_through WollokCookie

  def transform_response(response)
    if errored? response
      [extract_compilation_errors(response), :errored]
    elsif response['consoleOutput'].present?
      [trim_cookie_output(response['consoleOutput']), :passed]
    elsif response['runtimeError'].present?
      [response['runtimeError']['message'], :failed]
    else
      [response.to_s, :errored]
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

object mumukiConsole {
  method println(anObject) {
     console.println(anObject)
  }
}

program mumuki {
  #{build_cookie_code(r)}
  #{
    if %w(var const).any? { |it| r.query.strip.start_with? it }
      "#{r.query}\nmumukiPrettyPrinter.prettyPrint(void)"
    else
      "mumukiPrettyPrinter.prettyPrint(#{r.query})"
    end
  }
}
WLK
  end

end
