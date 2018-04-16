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

  it 'answers a valid hash when the error checker is waiting for a wrong_arguments_quantity error' do
    response = bridge.run_tests!(
      content: "program{ \nDibujarLinea3(Verde)\n}",
      test: %q{
check_head_position: true

examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  error: wrong_arguments_quantity
},
      expectations: [ ],
      extra: "procedure DibujarLinea3(color, direccion) {\n Poner(color)\n Mover(direccion)\n Poner(color)\n Mover(direccion)\n Poner(color)\n}"
    )

    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a well formed error when the content has no program definition' do
    response = bridge.run_tests!(
      content: "",
      test: %q{
check_head_position: true

examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  error: wrong_arguments_quantity
},
      expectations: [ ],
      extra: ""
    )

    expect(response[:status]).to eq :errored
    expect(response[:response_type]).to eq :unstructured
    expect(response[:result]).to eq "<pre>[0:0]: No program definition was found</pre>"
  end

  # See https://github.com/mumuki/mulang/issues/144. Caused by not excluding the proper smells
  it 'checks an inspection over a function correctly' do
    response = bridge.run_tests!(
      {
        content: "function rojoEsDominante(){\nreturn (nroBolitas(Rojo)\u003enroBolitasTotal()-nroBolitas(Rojo))\n}",
        test: "subject: rojoEsDominante\n\nexamples:\n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 4 Verde 3\n     head 0 0\n   return: 'False'\n \n - initial_board: |\n     GBB/1.0\n     size 2 2\n     cell 0 0 Azul 3 Negro 2 Rojo 10 Verde 3\n     head 0 0\n   return: 'True'",
        expectations: [
          {
            binding: "rojoEsDominante",
            inspection: "HasUsage:todasMenos"
          }
        ],
        extra: "function nroBolitasTotal() {\n  return (nroBolitas(Azul) + nroBolitas(Negro) + nroBolitas(Rojo) + nroBolitas(Verde))\n}\n\nfunction todasMenos(color) {\n    return (nroBolitasTotal() - nroBolitas(color))\n}"
      }
    )
    expect(response[:status]).to eq :passed_with_warnings
    expect(response[:response_type]).to eq :structured

  end

  it 'answers a valid hash when locale is pt, with directions' do
    response = bridge.run_tests!({
        content: "program {\n  Mover(Sul); Mover(Leste)   \n}",
        test: "
        check_head_position: true
        examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 2
           final_board: |
             GBB/1.0
             size 3 3
             head 1 1",
        expectations: [ ],
        locale: "pt",
        extra: "",
      })
    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when locale is pt and submission is wrong, with directions' do
    response = bridge.run_tests!({
        content: "program {\n  Mover(Sul); Mover(Leste)   \n}",
        test: "
        check_head_position: true
        examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 2
           final_board: |
             GBB/1.0
             size 3 3
             head 0 0",
        expectations: [ ],
        locale: "pt",
        extra: "",
      })
    expect(response[:status]).to eq :failed
    expect(response[:response_type]).to eq :structured
  end

  it 'answers a valid hash when locale is pt, with colors' do
    response = bridge.run_tests!(
      {
        content: "program {\n  Colocar(Vermelho)    \n}",
        test: "
         examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 0
           final_board: |
             GBB/1.0
             size 3 3
             cell 0 0 Rojo 1
             head 0 0",
        expectations: [ ],
        locale: "pt",
        extra: "",
      }
    )
    expect(response[:status]).to eq :passed
    expect(response[:response_type]).to eq :structured
  end


  it 'fails when locale is pt and the content of the submission is wrong' do
    response = bridge.run_tests!(
      {
        content: "program {\n  Colocar(Preto)    \n}",
        test: "
         examples:
         - initial_board: |
             GBB/1.0
             size 3 3
             head 0 0
           final_board: |
             GBB/1.0
             size 3 3
             cell 0 0 Rojo 1
             head 0 0",
        expectations: [
        ],
        locale: "pt",
        extra: "",
      }
    )
    expect(response[:status]).to eq :failed
    expect(response[:response_type]).to eq :structured
  end

  it 'responds a properly structured response when there are unexpected booms and no expected final boards' do
    response = bridge.run_tests!(
      {
        content: "
          function hayBolitasLejosAl(direccion, color, distancia) {
            MoverN(distancia, direcion)
            return (True)
          }
          ",
        test: "
          subject: hayBolitasLejosAl

          examples:
           - arguments:
             - Norte
             - Rojo
             - 2
             initial_board: |
               GBB/1.0
               size 3 3
               cell 0 2 Rojo 1
               head 0 0
             return: 'True'",
        expectations: [
        ],
        extra: "procedure MoverN(n, direccion) { repeat (n) { Mover(direccion) } }"
      }
    )

    expect(response[:response_type]).to eq :structured
    expect(response[:status]).to eq :failed
  end

  it 'can accept Blockly XML as content' do
    response = bridge.run_tests!(
      content: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="Program" id="xB~]3G#lp3SsK`Ys{VS^" deletable="false" x="30" y="30"><mutation timestamp="1523891789396"></mutation><statement name="program"><block type="Asignacion" id="FW1Q]83JP$a0!!$wYxyd"><field name="varName">unColor</field><value name="varValue"><block type="ColorSelector" id="l4c.8v[N.mvxPf$Zx^VW"><field name="ColorDropdown">Negro</field></block></value><next><block type="Poner" id="C1cG`0n#kyzHT5WF88~L"><value name="COLOR"><block type="variables_get" id="jv[rAEP5uKPbN{RN[.I|"><mutation var="unColor"></mutation><field name="VAR">unColor</field></block></value><next><block type="Mover" id="RqKR#pt]B~yQuOg4(u$p"><value name="DIRECCION"><block type="DireccionSelector" id="t?xv9#gqOXx$iKiVH]S;"><field name="DireccionDropdown">Norte</field></block></value></block></next></block></next></block></statement></block></xml>',
      extra: '',
      expectations: [
        {binding: 'program', inspection: 'HasUsage:unColor'},
        {binding: 'program', inspection: 'Not:HasUsage:otraCosa'}
      ],
      test: '
check_head_position: true

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 0 Rojo 0 Verde 0 Negro 1
     head 0 1
    ')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "program", inspection: "Uses:=unColor", result: :passed},
                                                   {binding: "program", inspection: "Not:Uses:=otraCosa", result: :passed}
                                                 ],
                                                 result: ''
  end

  it 'can accept Blockly XML as extra AND content, using primitive actions' do
    response = bridge.run_tests!(
      content: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="Program" id="PuD+$,0HT^k)5IUPdU!?" deletable="false" x="150" y="-160"><mutation timestamp="1523892212925"></mutation><statement name="program"><block type="RepeticionSimple" id="YeG}Q75;8ra*Wp3:EU2q"><value name="count"><block type="dobleDe_" id="3/`k,b:TE+S9Y9qKDX~p"><value name="arg1"><block type="math_number" id="[op/fExN+uq4:U]0NqoH"><field name="NUM">3</field></block></value></block></value><statement name="block"><block type="PonerTres_" id="MGSh1,-~Pi}EJ7{pZ;mX"><value name="arg1"><block type="ColorSelector" id="veM!Uyw2$}S=hJtas!Cs"><field name="ColorDropdown">Azul</field></block></value></block></statement></block></statement></block></xml>',
      extra: '<xml xmlns="http://www.w3.org/1999/xhtml"><variables></variables><block type="procedures_defnoreturn" id="h#T:7OUn=gaPXqUplXe]" x="80" y="-207"><mutation><arg name="color"></arg></mutation><field name="NAME">PonerTres_</field><field name="ARG0">color</field><statement name="STACK"><block type="Poner" id="YcB^xSAiU-+sa4[z8wKO"><value name="COLOR"><block type="variables_get" id="rsm([Dp*s5Hi+*bWE}*i"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value><next><block type="Poner" id="jGqg=|!OChe?VZ0_dsUd"><value name="COLOR"><block type="variables_get" id="RawKnPa#tN{0vEvMFmY_"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value><next><block type="Poner" id="BnYamcc*iwjGM,-yoa}n"><value name="COLOR"><block type="variables_get" id="z#LO[/(O-spS=WQVeh)*"><mutation var="color" parent="h#T:7OUn=gaPXqUplXe]"></mutation></block></value></block></next></block></next></block></statement></block><block type="procedures_defreturnsimplewithparams" id=")(t47XNXCjl]b^(zV:4;" x="80" y="-8"><mutation statements="false"><arg name="número"></arg></mutation><field name="NAME">dobleDe_</field><field name="ARG0">número</field><value name="RETURN"><block type="OperadorNumerico" id=":}n%C$e}/%y;JdE1]`D("><field name="OPERATOR">*</field><value name="arg1"><block type="variables_get" id="h6)YVE)7%.KldhC)wE$~"><mutation var="número" parent=")(t47XNXCjl]b^(zV:4;"></mutation></block></value><value name="arg2"><block type="math_number" id="EB$._vZ}Qk+wIYcE:V74"><field name="NUM">2</field></block></value></block></value></block></xml>',
      expectations: [
        {binding: 'program', inspection: 'Uses:dobleDe_'},
        {binding: 'program', inspection: 'Uses:PonerTres_'}
      ],
      test: '
check_head_position: true

examples:
 - initial_board: |
     GBB/1.0
     size 4 4
     head 0 0
   final_board: |
     GBB/1.0
     size 4 4
     cell 0 0 Azul 18 Rojo 0 Verde 0 Negro 0
     head 0 0
    ')

    expect(response.except(:test_results)).to eq response_type: :structured,
                                                 status: :passed,
                                                 feedback: '',
                                                 expectation_results: [
                                                   {binding: "program", inspection: "Uses:dobleDe_", result: :passed},
                                                   {binding: "program", inspection: "Uses:PonerTres_", result: :passed}
                                                 ],
                                                 result: ''
  end
end
