class Directives::Sections
  def sections_regexp
    /\/\*<(.+?)#\*\/(.+?)\/\*#(.+?)>\*\//
  end

  def split_sections(code)
    sections = code.captures(sections_regexp).map do
      [$1, $2]
    end
    Hash[sections]
  end

  def transform(sections)
    result = {}
    sections.each do |key, code|
      new_sections = split_sections(code)
      if new_sections.present?
        result.merge!(new_sections)
      else
        result[key] = code
      end
    end
    result
  end
end
