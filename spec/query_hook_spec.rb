require_relative '../lib/wollok_runner'

describe WollokQueryHook do
  let(:hook) { WollokQueryHook.new }
  let(:result) {
    hook.compile_program OpenStruct.new content: 'var x = 4', extra: '/*[IgnoreContentOnQuery]*/ object foo {}', query: 'foo'
  }

  it { expect(result).to include 'foo' }
  it { expect(result).to include 'object foo {}' }
  it { expect(result).to_not include 'var x = 4' }

end