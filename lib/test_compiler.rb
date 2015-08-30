class TestCompiler < Mumukit::FileTestCompiler

  def create_tempfile
    Tempfile.new(%w(compilation .wtest))
  end

  def compile(request)
<<EOF
#{request.content}
#{request.extra}
#{request.test}
EOF
  end
end
