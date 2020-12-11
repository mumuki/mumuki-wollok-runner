require_relative 'spec_helper'
require_relative '../lib/wollok_runner'

describe WollokQueryHook do
  let(:hook) { WollokQueryHook.new }
  let(:result) {
    hook.compile_program struct content: 'object x {}', extra: 'object foo {}', query: 'foo'
  }

  it { expect(result).to include 'foo' }
  it { expect(result).to include 'object foo {}' }
  it { expect(result).to include 'object x {}' }
  it { expect(result).to include 'object mumukiConsole' }
  it { expect(result).to include 'object mumukiPrettyPrinter' }

end
