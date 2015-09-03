require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new('wollok_command' => '.heroku/vendor/wollok-standalone/bin/winterpreter.sh') }

  describe '#run' do
    context 'on failed submission' do
      let(:file) { 'spec/data/failed/compilation.wtest' }
      let(:result) { runner.run_test_dir!(file) }

      it { expect(result[1]).to eq :failed }
      it { expect(result[0]).to include 'There was 1 failure' }
    end

    context 'on passed submission' do
      let(:file) { 'spec/data/passed/compilation.wtest' }
      let(:result) { runner.run_test_dir!(file) }

      it { expect(result[1]).to eq :passed }
    end
  end
end
