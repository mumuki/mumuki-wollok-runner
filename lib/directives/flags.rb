class Directives::Flags
  def flags(code)
    code.captures(flag_regexp).map { $1 }
  end

  def flag_regexp
    /\/\*\[(.+?)\]\*\//
  end

  def active?(flag, code)
    flags(code).include? flag
  end

  def transform(sections)
    if active?('IgnoreContentOnQuery', sections['extra']) && sections['query'].present?
      sections.except('content')
    else
      sections
    end
  end


end