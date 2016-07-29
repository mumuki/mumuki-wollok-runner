class Interpolator
  def interpolation_regexp
    /\/\*\.\.\.(.+?)\.\.\.\*\//
  end

  def interpolations?(code)
    (code =~ interpolation_regexp).present?
  end

  def interpolate(code, replacements)
    replacements = replacements.stringify_keys
    code.gsub(interpolation_regexp) do
      replacements[$1]
    end
  end

  def try_interpolate(key, sections)
    code = sections[key]
    if interpolations? code
      interpolate code, sections.except(key)
    else
      yield sections if block_given?
    end
  end

  def sections(code)
    sections = code.gsub(/\/\*<(.+?)#\*\/(.+?)\/\*#(.+?)>\*\//).map do
      [$1, $2]
    end
    Hash[sections]
  end
end
