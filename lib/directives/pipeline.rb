class Directives::Pipeline
  def initialize(directives)
    @directives = directives
  end

  def transform(request)
    base_sections = request.to_stringified_h
    rest = base_sections.slice!('test', 'extra', 'content', 'query')

    @directives
        .inject(base_sections) { |sections, it| it.transform(sections) }
        .amend(rest)
        .to_struct
  end
end
    