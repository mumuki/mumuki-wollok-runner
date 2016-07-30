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

  def compile_program(request)
    compile_program_after_directives(directives_pipeline.transform(request))
  end

  def directives_pipeline
    @pipeline ||= Directives::Pipeline.new [Directives::Sections.new,
                                            Directives::Interpolations.new('test'),
                                            Directives::Interpolations.new('extra'),
                                            Directives::Flags.new]
  end
end