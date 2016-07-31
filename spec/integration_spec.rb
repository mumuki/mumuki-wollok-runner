require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'supports queries that pass' do
    response = bridge.run_query!(query: 'x.y() + 1', extra: '', content: 'object x { method y() = 3 }', expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to include '=> 4'
  end

  it 'supports queries that don\'t compile' do
    response = bridge.run_query!(query: 'bleh', extra: '', content: '', expectations: [])

    expect(response[:status]).to eq(:failed)
    expect(response[:result]).to include "ERROR: Couldn't resolve reference to Referenciable 'bleh'."
  end

  it 'supports queries that return void' do
    response = bridge.run_query!(query: 'void', extra: '', content: '', expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=>\n"
  end


  it 'supports queries that return null' do
    response = bridge.run_query!(query: 'null', extra: '', content: 'object x { method y() = 3 }', expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=>\n"
  end

  it 'supports queries with cookie' do
    response = bridge.run_query!(query: 'x',
                                 extra: 'object x { var y = 0; method m() = y++ }',
                                 content: '',
                                 cookie: ['x.m()', 'x.m()'])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=> x[y=2]\n"
  end

  it 'supports queries with cookie and console' do
    response = bridge.run_query!(query: 'x.m()',
                                 extra: 'object x { method m() { mumukiConsole.println("hello") } } ',
                                 content: '',
                                 cookie: ['x.m()', 'x.m()'])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "hello\n=>\n"
  end

  it 'supports queries with runtime errors' do
    response = bridge.run_query!(query: 'x.y() + 1', extra: '', content: 'object x { method y() = true }', expectations: [])

    expect(response[:status]).to eq(:failed)
    expect(response[:result]).to include 'true does not understand +'
  end

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 6" {
  assert.equals(6, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:response_type]).to eq(:structured)
    expect(response[:status]).to eq(:passed)
    expect(response[:test_results]).to eq [{title: 'foo.bar() is 6', status: :passed, result: nil}]
  end

  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 6" {
  assert.equals(5, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:response_type]).to eq(:structured)
    expect(response[:status]).to eq(:failed)
    expect(response[:test_results]).to eq [{title: 'foo.bar() is 6',
                                            status: :failed,
                                            result: "wollok.lang.Exception: Expected [5] but found [6]\n\tat wollok.lib.assert.equals(expected,actual) [/lib.wlk:61]\n\tat  [__synthetic0.wtest]\n"}]
  end

  it 'answers a valid hash when submission has compilation errors' do
    response = bridge.run_tests!(test: %q{
tes "foo.bar() is 6" {
  assert.equals(5, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:response_type]).to eq(:unstructured)
    expect(response[:status]).to eq(:errored)
    expect(response[:result]).to include "ERROR: missing EOF at 'tes'"
  end

  it 'answers a valid hash when submission has runtime errors' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 6" {
  asser.equals(5, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:response_type]).to eq(:structured)
    expect(response[:test_results][0][:result]).to include 'org.uqbar.project.wollok.interpreter.WollokInterpreterException'
  end

end