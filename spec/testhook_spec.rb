require_relative '../lib/wollok_runner'

describe WollokTestHook do
  let(:hook) { WollokTestHook.new }

  context 'no extra' do
    let(:result) {
      hook.compile_program struct content: '', test: 'test "zaraza" {
  var x = 4
  assert.that(x === 4)
}'
    }

    it { expect(result).to eq 'object mumukiConsole {
  method println(anObject) {
     console.println(anObject)
  }
}



test "zaraza" {
  var x = 4
  assert.that(x === 4)
}
'
    }
  end
end