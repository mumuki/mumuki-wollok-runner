class Flags
  def flags(code)
    code.gsub(flag_regexp).map { $1 }
  end

  def flag_regexp
    /\/\*\[(.+?)\]\*\//
  end

  def transform(request)
    if flags(request[:extra]).include? 'IgnoreContentOnQuery'
      request.except(:content)
    else
      request
    end
  end
end