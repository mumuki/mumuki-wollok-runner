class Directives::Pipeline
  def initialize(directives)
    @directives = directives
  end

  def transform(request)
    base_sections = {'test' => request.test,
                     'extra' => request.extra,
                     'content' => request.content,
                     'query' => request.query}
    OpenStruct.new @directives.inject(base_sections) { |sections, it| it.transform(sections) }
  end
end