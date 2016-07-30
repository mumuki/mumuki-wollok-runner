require_relative '../lib/wollok_server'

describe 'sections' do
  let(:s) { Directives::Sections.new }

  it { expect(s.split_sections 'foo').to eq({}) }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/').to eq 'baz' => 'lalala' }
  it { expect(s.split_sections 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/').to eq 'baz' => 'lalala', 'bar' => 'lelele' }

  it { expect(s.transform('foo' => 'bar',
                          'baz' => 'foobar')).to eq 'foo' => 'bar',
                                                    'baz' => 'foobar' }
  it { expect(s.transform('foo' => 'bar',
                          'foobar' => 'foo /*<baz#*/lalala/*#baz>*/ ignored /*<bar#*/lelele/*#bar>*/')).to eq 'foo' => 'bar',
                                                                                                              'baz' => 'lalala',
                                                                                                              'bar' => 'lelele' }
end