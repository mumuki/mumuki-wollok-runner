require_relative '../lib/wollok_server'

describe WollokTestHook do
  let(:hook) { WollokTestHook.new }
  let(:result) {
    hook.compile_program OpenStruct.new content: 'var x = 4', test: '
    test "zaraza" {
      /*...content...*/
      assert.that(x === 4)
    }'
  }

  it { expect(result).to eq '
    test "zaraza" {
      var x = 4
      assert.that(x === 4)
    }'
  }
end