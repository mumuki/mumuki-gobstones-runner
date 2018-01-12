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
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  final_board: |
    GBB/1.0
    size 3 3
    head 0 1
- initial_board: |
    GBB/1.0
    size 2 2
    head 0 0
  final_board: |
    GBB/1.0
    size 2 2
    head 0 1
}}

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: test, extra: '', content: %q{
program {
  Mover(Norte)
}}, expectations: [])

    expect(response[:status]).to eq :passed
    expect(response[:test_results].size).to eq 2
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when submission passes, in gobstones' do
    # // TODO: Use the old mulang syntax

    response = bridge.run_tests!(
      content: '
procedure PonerUnaDeCada() {
    Poner (Rojo)
    Poner (Azul)
    Poner (Negro)
    Poner (Verde)
}',
      extra: '',
      expectations: [
        {binding: 'program', inspection: 'Uses:PonerUnaDeCada'},
        {binding: '*', inspection: 'Not:Declares:program'},
        {binding: '*', inspection: 'Declares:PonerUnaDeCada'}
      ],
      test: '
check_head_position: true

subject: PonerUnaDeCada

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 1 Rojo 1 Verde 1 Negro 1
     head 0 0

 - initial_board: |
     GBB/1.0
     size 5 5
     head 3 3
   final_board: |
     GBB/1.0
     size 5 5
     cell 3 3 Azul 1 Rojo 1 Verde 1 Negro 1
     head 3 3')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed_with_warnings,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: 'program', inspection: 'Uses:PonerUnaDeCada', result: :failed},
                                                   {binding: '*', inspection: 'Not:Declares:program', result: :passed},
                                                   {binding: '*', inspection: 'Declares:PonerUnaDeCada', result: :passed}],
                                                 result: ''
    expect(response[:test_results].size).to eq 2
  end

# // TODO: Use the old mulang syntax, swapping binding and target.
# // TODO: Another problem is that currently "Declares:HastaElInfinite" is converted to "Declares"
#   it 'answers a valid hash when submission is aborted and expected, in gobstones' do
#     response = bridge.run_tests!(
#       language: :gobstones,
#       content: '
# procedure HastaElInfinito() {
#   while (puedeMover(Este)) {
#     Poner(Rojo)
#   }
# }',
#       extra: '',
#       expectations: [
#         {:binding=>"*", :inspection=>"Not:Declares:program"},
#         {:binding=>"*", :inspection=>"Declares:HastaElInfinito"}
#       ],
#       test: '
# subject: HastaElInfinito
# expect_endless_while: true
# examples:
#  - initial_board: |
#      GBB/1.0
#      size 2 2
#      head 0 0
#    final_board: |
#      GBB/1.0
#      size 2 2
#      head 0 0')
#
#     expect(response.except(:test_results)).to eq response_type: :structured,
#                                                  status: :passed,
#                                                  feedback: '',
#                                                  expectation_results: [
#                                                    {:binding=>"*", :inspection=>"Not:Declares:program", :result=>:passed},
#                                                    {:binding=>"*", :inspection=>"Declares:HastaElInfinito", :result=>:passed}],
#                                                  result: ''
#   end
end
