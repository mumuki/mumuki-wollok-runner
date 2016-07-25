class WollokHook < Mumukit::Hook

  def run!(request)
    transform_response JSON.pretty_parse(RestClient.post(server_path, request.to_json))
  end

  def compile(request)
    {program: compile_program(request),
     programType: program_type}
  end

  def server_path
    'http://server.wollok.org:8080/run'
  end
end