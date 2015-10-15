require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Bridge.new('http://localhost:4568') }

  #before(:all) do
  #  @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
  #  sleep 8
  #end
  #after(:all) { Process.kill 'TERM', @pid }

  pending 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 6" {
  assert.equals(6, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:status]).to eq(:passed)
  end


  pending 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: %q{
test "foo.bar() is 6" {
  assert.equals(5, foo.bar())
}}, extra: '', content: %q{
object foo {
  method bar() {
    return 6
  }
}}, expectations: [])

    expect(response[:status]).to eq(:failed)
  end



end
