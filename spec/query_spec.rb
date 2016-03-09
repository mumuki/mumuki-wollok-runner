require_relative './spec_helper'

describe QueryHook do
  let(:hook) { QueryHook.new('wollok_command' => 'wdk/bin/winterpreter.sh') }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }

  describe 'should pass on ok request' do
    let(:okCode) { 'object pepita { method energia() = 2 }' }
    let(:okQuery) { 'pepita.energia()' }

    let(:request) { qreq(okCode, okQuery) }
    it do
      expect(result[1]).to eq :passed
      expect(result[0]).to include "=> 2\n"
    end
  end

  describe 'should pass on ok request with cookie' do
    let(:okCode) { '' }
    let(:okQuery) { 'x' }
    let(:cookie) { ['var x = 1', 'x += 1', 'x += 1'] }

    let(:request) { qreq(okCode, okQuery, '', cookie) }
    it do
      expect(result[1]).to eq :passed
      expect(result[0]).to include "=> 3\n"
    end
  end

  describe 'should pass on ok request with cookie that fails' do
    let(:okCode) { '' }
    let(:okQuery) { 'x' }
    let(:cookie) { ['var x = 1', 'throw new Exception(\'ups\')', 'x += 1'] }

    let(:request) { qreq(okCode, okQuery, '', cookie) }
    it do
      expect(result[1]).to eq :passed
      expect(result[0]).to include "=> 2\n"
    end

  end

  describe 'should pass on ok request with query dependent on extra' do
    let(:okCode) { 'object entrenador { method entrenada() = pepita }' }
    let(:okQuery) { 'entrenador.entrenada() == pepita' }
    let(:okExtra) { 'object pepita {}' }

    let(:request) { qreq(okCode, okQuery, okExtra) }
    it do
      expect(result[1]).to eq :passed
      expect(result[0]).to include "=> true\n"
    end
  end
end

