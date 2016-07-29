require_relative '../lib/wollok_server'

describe 'interpolate' do
  let(:interpolator) { Interpolator.new }

  it { expect(interpolator.interpolations? '').to be false }
  it { expect(interpolator.interpolations? 'test "foo" {}').to be false }
  it { expect(interpolator.interpolations? 'test "foo" { /* here there is a test */ }').to be false }
  it { expect(interpolator.interpolations? 'test "foo" { /**/ }').to be false }
  it { expect(interpolator.interpolations? 'test "foo" { /*......*/ }').to be false }
  it { expect(interpolator.interpolations? 'test "foo" { /*...foo...*/ }').to be true }


  it { expect(interpolator.interpolate 'foo', {}).to eq 'foo' }
  it { expect(interpolator.interpolate 'foo', {bar: 'lalala'}).to eq 'foo' }
  it { expect(interpolator.interpolate 'foo /*...foo...*/', {bar: 'lalala'}).to eq 'foo ' }
  it { expect(interpolator.interpolate 'foo /*...bar...*/', {bar: 'lalala'}).to eq 'foo lalala' }
  it { expect(interpolator.interpolate 'foo /*...bar...*/ /*...bar...*/', {bar: 'lalala'}).to eq 'foo lalala lalala' }
  it { expect(interpolator.interpolate 'foo /*...baz...*/ /*...bar...*/', {bar: 'lalala', baz: 'lelele'}).to eq 'foo lelele lalala' }

  it { expect(interpolator.sections 'foo').to eq({}) }
  it { expect(interpolator.sections 'foo /*<baz#*/lalala/*#baz>*/').to eq 'baz' => 'lalala' }
  it { expect(interpolator.sections 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/').to eq 'baz' => 'lalala', 'bar' => 'lelele' }


  it { expect(interpolator.try_interpolate(:test,
                                           test: 'baz',
                                           extra: 'bar',
                                           content: 'foo') { |it| it[:content] }).to eq 'foo' }
  it { expect(interpolator.try_interpolate(:test,
                                           test: '/*...content...*/ baz /*...extra...*/',
                                           extra: 'bar',
                                           content: 'foo') { |it| it[:content] }).to eq 'foo baz bar' }
  it { expect(interpolator.try_interpolate(:test,
                                           test: '/*...content...*/ baz /*...extra...*/',
                                           content: 'foo') { |it| it[:content] }).to eq 'foo baz ' }

end