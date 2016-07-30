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

require_relative './directives/flags'
require_relative './directives/interpolations'
require_relative './directives/sections'
require_relative './directives/pipeline'
