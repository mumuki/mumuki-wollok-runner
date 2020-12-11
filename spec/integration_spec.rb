require_relative 'spec_helper'
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
    expect(response[:result]).to eq "=> 4\n"
  end

  it 'supports queries that declare vars' do
    response = bridge.run_query!(query: 'var x = 1', extra: '', content: '', expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=>\n"
  end

  it 'supports queries that uses vars' do
    response = bridge.run_query!(query: 'x', extra: '', content: '', expectations: [], cookie: ['var x = 1'])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=> 1\n"
  end

  it 'supports queries that don\'t compile' do
    response = bridge.run_query!(query: 'bleh', extra: '', content: '', expectations: [])

    expect(response[:status]).to eq(:errored)
    expect(response[:result]).to eq "ERROR: Couldn't resolve reference to Referenciable 'bleh'."
  end

  it 'supports queries that don\'t compile but could execute' do
    response = bridge.run_query!(query: 'foo.bar', extra: 'object foo { }', content: '', expectations: [])

    expect(response[:status]).to eq(:errored)
    expect(response[:result]).to eq "ERROR: Bad message: bar)"
  end

  it 'supports queries that return void' do
    response = bridge.run_query!(query: 'void', extra: '', content: '', expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=>\n"
  end

  it 'supports queries that do not produce a value' do
    response = bridge.run_query!(query: 'f.m()', extra: '', content: 'object f { var z = 1 method m() { z -= 1 } }', expectations: [])

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

  it 'supports queries with cookie and exceptions' do
    response = bridge.run_query!(query: 'x',
                                 extra: '',
                                 content: '',
                                 cookie: ['var x = 1', 'x += 2', 'throw new Exception()', 'x += 1'])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=> 4\n"
  end

  pending 'supports queries with cookie and exceptions thrown with error object' do
    response = bridge.run_query!(query: 'x',
                                 extra: '',
                                 content: '',
                                 cookie: ['var x = 1', 'x += 2', 'error.throwWithMessage("foo")', 'x += 1'])

    expect(response[:status]).to eq(:failed)
    expect(response[:result]).to eq "=> 4\n"
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
    expect(response[:result]).to eq 'true does not understand +(param1)'
  end

  it 'supports queries with interpolations pass' do
    response = bridge.run_query!(query: 'foo.x()',
                                 extra: '/*[IgnoreContentOnQuery]*/ object foo { method x() = 5 }',
                                 content: 'var x = 3',
                                 expectations: [])

    expect(response[:status]).to eq(:passed)
    expect(response[:result]).to eq "=> 5\n"
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
                                            result: 'Expected [5] but found [6]'}]
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
    expect(response[:result]).to eq "ERROR: Bad structure: tes definition must be before object."
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

    expect(response).to eq response_type: :unstructured,
                           test_results: [],
                           status: :errored,
                           feedback: '',
                           expectation_results: [],
                           result: "ERROR: Couldn't resolve reference to Referenciable 'asser'."
  end

  it 'answers a valid hash when submission has attributes syntax errors' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 5" {
  asser.equals(5, foo.bar())
}}, extra: '', content: %q{
object foo {
  x = 5
  method bar() {
    return 5
  }
}}, expectations: [])

    expect(response).to eq response_type: :unstructured,
                           test_results: [],
                           status: :errored,
                           feedback: '',
                           expectation_results: [],
                           result: "ERROR: mismatched input 'x' expecting '}'\nERROR: Couldn't resolve reference to Referenciable 'asser'."
  end

  it 'answers a valid hash when submission has methods compile errors' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 5" {
  asser.equals(5, foo.bar())
}}, extra: '', content: '
object foo {
  method bar() {
    return 5
}', expectations: [])

    expect(response).to eq response_type: :unstructured,
                           test_results: [],
                           status: :errored,
                           feedback: '',
                           expectation_results: [],
                           result: "ERROR: Tests are not allowed in object definition.\nERROR: Couldn't resolve reference to Referenciable 'asser'."
  end

  it 'includes describe text in title when given' do
    response = bridge.run_tests!(test: %q{
describe "Numbers:" {
  test "six equals six" {
    assert.equals(6, 6)
  }}}, extra: '', content: '', expectations: [])

    expect(response[:response_type]).to eq(:structured)
    expect(response[:status]).to eq(:passed)
    expect(response[:test_results]).to eq [{title: 'Numbers: six equals six', status: :passed, result: nil}]
  end
end
