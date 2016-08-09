require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: 'foo', extra: '', content: %q{
MOV R3, 0x0003
MOV R5, 0x0004
ADD R3, R5}, expectations: [])

    expect(response[:result]).to include('records')
    expect(response[:status]).to eq(:passed)
  end
end
