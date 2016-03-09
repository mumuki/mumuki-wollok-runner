require_relative '../lib/wollok_server'

def treq(content='', test='', extra='')
  OpenStruct.new(content: content, test: test, extra: extra)
end

def qreq(content='', query='', extra='', cookie=[])
  OpenStruct.new(content: content, query: query, extra: extra, cookie: cookie)
end

class File
  def unlink
  end
end
