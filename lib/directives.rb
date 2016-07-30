module Directives
end

class String
  alias_method :captures, :gsub
end

class NilClass
  def captures(*)
    []
  end
end

class Object
  def to_stringified_h
    to_h.stringify_keys
  end
end

class Hash
  def to_struct
    OpenStruct.new self
  end

  def amend(other)
    other.merge(self)
  end
end

require_relative './directives/flags'
require_relative './directives/interpolations'
require_relative './directives/sections'
require_relative './directives/pipeline'
