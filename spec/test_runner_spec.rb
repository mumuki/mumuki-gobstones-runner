require_relative './spec_helper'
require_relative './data/fixture'

describe 'running' do
  include Fixture

  def req(content, extra, test = 'examples: [{}]')
    struct content: content.strip, extra: extra.strip, test: test
  end

  let(:runner) { QsimTestHook.new }

  describe '#compile_file_content' do
    let(:content) {
<<EOF
MOV R1, 0x0004
CALL duplicateR1
EOF
    }

    let(:extra) {
<<EOF
duplicateR1:
MUL R1, 0x0002
RET
EOF
    }

    let(:test) {
%q{
examples:
- name: 'R2 stores the sum of R0 and R1'
  preconditions:
    records:
      R0: 'B5E1'
      R1: '000F'
  postconditions:
    equal:
      R2: 'B5F0'}}

    let(:request) { req content, extra, test }
    let!(:result) { runner.compile_file_content request }

    context 'compiles the code and the preconditions' do
      let(:expected_compiled_code) {
        <<EOF
CALL main

duplicateR1:
MUL R1, 0x0002
RET

main:
MOV R1, 0x0004
CALL duplicateR1
!!!BEGIN_EXAMPLES!!!
[{"special_records":{"PC":"0000","SP":"FFEF","IR":"0000"},"flags":{"N":0,"Z":0,"V":0,"C":0},"records":{"R0":"B5E1","R1":"000F"},"memory":{},"id":0}]
EOF
      }

      it { expect(result).to eq expected_compiled_code }
    end

    context 'parses the examples' do
      let(:expected_example) {
        {
            id: 0,
            name: 'R2 stores the sum of R0 and R1',
            preconditions: {
                records: {R0: 'B5E1', R1: '000F'}
            },
            postconditions: {
                equal: {R2: 'B5F0'}
            }
        }
      }
      it { expect(runner.examples).to eq [expected_example] }
    end
  end

  describe '#execute!' do
    let(:request) { req q1_ok_program, '' }
    let(:result) { runner.execute! request }

    let(:expected_result) {{
        special_records: { PC: '0007', SP: 'FFEE', IR: '28E5 ' },
        flags: { N: 0, Z: 0, V: 0, C: 0 },
        records: {
            R0: '0000', R1: '0000', R2: '0000', R3: '0007',
            R4: '0000', R5: '0004', R6: '0000', R7: '0000'
        }
    }}

    it { expect(result.first).to include expected_result }
  end

  describe '#run!' do
    let(:file) { runner.compile(req content, '', test.to_yaml) }
    let(:test) { {examples: examples} }
    let(:examples) { [{}] }
    let(:result) { runner.run!(file) }

    context 'when program finishes' do
      let(:examples) {
        [{
          name: 'R3 is 0007',
          operation: :run,
          postconditions: {equal: {R3: '0007'}}
         }]
      }

      let(:content) { q1_ok_program }
      let(:example_result) { result[0][0] }

      it { expect(example_result[0]).to eq 'R3 is 0007' }
      it { expect(example_result[1]).to eq :passed }
      it { expect(example_result[2]).to include '<table' }
    end

    context 'with records preconditions' do
      let(:examples) {
        [{
             name: 'R1 is 0008',
             preconditions: { records: {R1: '0005', R2: '0003'} },
             operation: :run,
             postconditions: {equal: {R1: '0008'}}
         }]
      }

      let(:content) { sum_r1_r2_program }
      let(:example_result) { result[0][0] }

      it { expect(example_result[0]).to eq 'R1 is 0008' }
      it { expect(example_result[1]).to eq :passed }
      it { expect(example_result[2]).to include '<table' }
    end

    context 'with multiple examples and preconditions' do
      let(:examples) {
        [{
             name: 'R1 is 0008',
             preconditions: { records: {R1: '0005', R2: '0003'} },
             operation: :run,
             postconditions: {equal: {R1: '0008'}}
         }, {
             name: 'R1 is 0010',
             preconditions: { records: {R1: '000E', R2: '0001'} },
             operation: :run,
             postconditions: {equal: {R1: '0010'}}
        }]
      }

      let(:content) { sum_r1_r2_program }
      let(:example_results) { result[0] }

      it { expect(example_results[0][1]).to eq :passed }
      it { expect(example_results[1][1]).to eq :failed }
    end

    context 'when program fails with syntax error' do
      let(:content) { syntax_error_program }
      let(:expected_result) { 'Ha ocurrido un error en la linea 2 : ' }

      it { expect(result[1]).to eq :errored  }
      it { expect(result[0]).to eq expected_result }
    end

    context 'when program fails with runtime error' do
      let(:content) { runtime_error_program }
      let(:expected_result) { 'Una de las etiquetas utilizadas es invalida' }

      it { expect(result[1]).to eq :errored  }
      it { expect(result[0]).to eq expected_result }
    end
  end
end
