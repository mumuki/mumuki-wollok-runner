require_relative 'spec_helper'

describe TestCompiler do
  def req(test, extra, content)
    OpenStruct.new(test:test, extra:extra, content: content)
  end

  true_test = <<EOT
test "true is true" {
  assert.equals(true, true)
}
EOT

  compiled_test_submission = <<EOT
object foo {}
object bar {}
test "true is true" {
  assert.equals(true, true)
}

EOT

  describe '#compile' do
    let(:compiler) { TestCompiler.new(nil) }
    it { expect(compiler.compile(req(true_test, 'object bar {}',  'object foo {}'))).to eq(compiled_test_submission) }
  end
end
