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

  it 'answers a valid hash when submission passes and boards do not have a GBB spec' do
    response = bridge.run_tests!(test: %q{
examples:
- initial_board: |
    size 3 3
    head 0 0
  final_board: |
      size 3 3
      head 0 1}, extra: '', content: %q{
program {
  Mover(Norte)
}}, expectations: [])

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when submission passes, with expectations' do
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
        {binding: 'program', inspection: 'HasUsage:PonerUnaDecada'},
        {binding: 'program', inspection: 'Not:HasBinding'},
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
                                                   {binding: "program", inspection: "Uses:=PonerUnaDecada", result: :failed},
                                                   {binding: "*", inspection: "Not:Declares:=program", result: :passed},
                                                   {binding: "*", inspection: "Declares:=PonerUnaDeCada", result: :passed}
                                                 ],
                                                 result: ''
    expect(response[:test_results].size).to eq 2
  end

  it 'answers a valid hash when submission is aborted and expected' do
    response = bridge.run_tests!(
      content: '
procedure HastaElInfinito() {
  while (puedeMover(Este)) {
    Poner(Rojo)
  }
}',
      extra: '',
      expectations: [
        {binding: "program", inspection: "Not:HasBinding"},
      ],
      test: '
subject: HastaElInfinito
expect_endless_while: true
examples:
 - initial_board: |
     GBB/1.0
     size 2 2
     head 0 0
   final_board: |
     GBB/1.0
     size 2 2
     head 0 0')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "*", inspection: "Not:Declares:=program", result: :passed},
                                                   {binding: "*", inspection: "Declares:=HastaElInfinito", result: :passed}
                                                 ],
                                                 result: ''
  end

  it 'answers a valid hash when the expected boom type is wrong_arguments_type' do
    response = bridge.run_tests!(
      content: "program {\nDibujarLinea3(Este, Verde)\nMover(Este)\nDibujarLinea3(Norte, Rojo)\nMover(Norte)\nDibujarLinea3(Oeste, Negro)\nMover(Oeste)\nDibujarLinea3(Sur, Azul)\n}",
      extra: "procedure DibujarLinea3(color, direccion) {\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n  Mover(direccion)\n  Poner(color)\n }",
      expectations: [],
      test: "check_head_position: true\n\nexamples:\n - title: '¡BOOM!'\n   initial_board: |\n     GBB/1.0\n     size 3 3\n     head 0 0\n   error: wrong_argument_type")

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the expected boom type is unassigned_variable and the initial board is not defined' do
    response = bridge.run_tests!(
      content: "function boomBoomKid() {\n  return (unaVariableQueNoExiste)\n}",
      test: "subject: boomBoomKid\n\nshow_initial_board: false\n\nexamples:\n - error: unassigned_variable",
      expectations: [],
      extra: ""
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the return checker has to compare a return value of True' do
    response = bridge.run_tests!(
      content: "function esLibreCostados(){\nreturn(puedeMover(Este)&&puedeMover(Oeste))\n\n}",
      test: "subject: esLibreCostados\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 3 2\n     head 0 0\n   return: 'False'\n \n - initial_board: |\n     GBB/1.0\n     size 3 2\n     head 1 0\n   return: 'True'",
      expectations: [
        {
          binding: "esLibreCostados",
          inspection: "HasUsage:puedeMover"
        }
      ],
      extra: "",
    )

     expect(response[:status]).to eq :passed
     expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when the return checker has to compare a numeric value and it is defined in the test as string' do
    response = bridge.run_tests!(
      content: "function numero(){\nvalor:=cifra()\nMover(Este)\nvalor:=(valor*100)+(cifra()*10)\nMover(Este)\nvalor:=(valor+cifra())\nreturn(valor)\n}",
      test: "subject: numero\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 3 1\n     cell 0 0 Rojo 1\n     cell 1 0 Rojo 3\n     cell 2 0 Rojo 2\n     head 0 0\n   return: '132'\n\n - initial_board: |\n     GBB/1.0\n     size 3 1\n     cell 0 0 Rojo 6\n     cell 1 0 Rojo 7\n     cell 2 0 Rojo 8\n     head 0 0\n   return: '678'",
      expectations: [
        {
          binding: "numero",
          inspection: "HasDeclaration"
        },
        {
          binding: "numero",
          inspection: "HasUsage:cifra"
        }
      ],
      extra: "function cifra() {\n  return (nroBolitas(Rojo))\n}"
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end
end
