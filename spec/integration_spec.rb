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
- name: 'Result is OK'
  preconditions:
    records:
      R0: 'B5E1'
      R1: '000F'
  postconditions:
    equal:
      R2: 'B5F0'

- name: 'Records are not modified'
  preconditions:
    records:
      R0: '0001'
      R1: '000A'
  postconditions:
    equal:
      R0: '0001'
      R1: '000A'}}

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: test, extra: '', content: %q{
ADD R2, R0
ADD R2, R1}, expectations: [])

    expect(response[:response_type]).to eq :structured
    expect(response[:test_results].size).to eq 2
    expect(response[:status]).to eq :passed
  end
end
