require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end

  after(:all) { Process.kill 'TERM', @pid }

  let(:test) {
    %q{
examples:
- name: 'R3 is 0007'
  postconditions:
    equal:
      R3: '0007'
- name: 'R5 is 0004'
  postconditions:
    equal:
      R5: '0004'}}

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: test, extra: '', content: %q{
MOV R3, 0x0003
MOV R5, 0x0004
ADD R3, R5}, expectations: [])

    expect(response[:response_type]).to eq :structured
    expect(response[:test_results].size).to eq 2
    expect(response[:status]).to eq :passed
  end
end
