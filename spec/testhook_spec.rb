require_relative '../lib/wollok_server'

describe WollokTestHook do
  let(:hook) { WollokTestHook.new }

  context 'no extra' do
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
        }
'
    }
  end

  context 'extra with flags' do
    let(:result) {
      hook.compile_program OpenStruct.new content: 'var x = 4', test: '
        test "zaraza" {
          /*...content...*/
          assert.that(x === 4)
        }', extra: '/*[IgnoreContentOnQuery]*/'
    }

    it { expect(result).to eq '/*[IgnoreContentOnQuery]*/


        test "zaraza" {
          var x = 4
          assert.that(x === 4)
        }
'
    }
  end
end