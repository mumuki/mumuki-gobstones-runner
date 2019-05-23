require_relative './spec_helper'

describe 'running' do

  def req(content, extra, test = 'examples: [{}]')
    runner.compile(
      struct content: content.strip, extra: extra.strip, test: test
    )
  end

  let(:runner) { GobstonesPrecompileHook.new }

  describe '#compile_file_content' do
    let(:content) {
<<EOF
program {
  PonerDosRojas()
}
EOF
    }

    let(:extra) {
<<EOF
procedure PonerDosRojas() {
  Poner(Rojo)
  Poner(Rojo)
}
EOF
    }

    let(:test) {
%q{
check_head_position: true
expect_endless_while: true
examples:
- title: A name
  initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  final_board: |
    GBB/1.0
    size 3 3
    head 0 1
  return: 29
- title: BOOM with 1x1
  initial_board: |
    GBB/1.0
    size 1 1
    head 0 0
  error: out_of_board
}}

    let(:request) { req content, extra, test }
    let!(:result) { runner.compile_file_content request }

    context 'parses the examples' do
      let(:expected_examples) {
        [
          {
            id: 0,
            name: "A name",
            preconditions: {
              initial_board: "GBB/1.0\nsize 3 3\nhead 0 0\n",
            },
            postconditions: {
              final_board: "GBB/1.0\nsize 3 3\nhead 0 1\n",
              return: 29
            }
          },
          {
            id: 1,
            name: "BOOM with 1x1",
            preconditions: {
              initial_board: "GBB/1.0\nsize 1 1\nhead 0 0\n",
            },
            postconditions: {
              error: "out_of_board"
            }
          }
        ]
      }

      it { expect(runner.batch.options).to eq show_initial_board: true,
                                        show_final_board: true,
                                        check_head_position: true,
                                        expect_endless_while: true,
                                        interactive: false,
                                        subject: nil }
      it { expect(runner.batch.examples).to eq expected_examples }
    end

    context 'parses the examples when the subject is specified, adding a default title and disabling show_final_board' do
      let(:test) {
%q{
subject: aName
examples:
- title:
  initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  return: 29
}}
      let(:expected_examples) {
        [
          {
            id: 0,
            name: "aName() -> 29",
            preconditions: {
              initial_board: "GBB/1.0\nsize 3 3\nhead 0 0\n",
            },
            postconditions: {
              return: 29
            }
          }
        ]
      }

      it { expect(runner.batch.options).to eq({
        show_initial_board: true,
        show_final_board: false,
        check_head_position: false,
        expect_endless_while: false,
        interactive: false,
        subject: "aName"
      }) }
      it { expect(runner.batch.examples).to eq expected_examples }
    end

    context 'generates a JSON with the batch request' do

      context 'when there is no subject' do
        let(:expected_code) { "program {\n  PonerDosRojas()\n}" }
        let(:expected_compilation) {
          {
            code: expected_code,
            extraCode: extra.chop,
            examples: [
              {
                initialBoard: "GBB/1.0\nsize 3 3\nhead 0 0\n",
                extraBoard: "GBB/1.0\nsize 3 3\nhead 0 1\n"
              },
              {
                initialBoard: "GBB/1.0\nsize 1 1\nhead 0 0\n"
              }
            ]
          }.to_json
        }

        it { expect(result).to eq expected_compilation }
      end

      context 'when there is a subject' do
        let(:content) { "things" }
        let(:expected_compilation) {
          {
            code: content,
            extraCode: extra.chop,
            examples: [
              {
                initialBoard: "GBB/1.0\nsize 3 3\nhead 0 0\n",
                generatedCode: expected_code
              }
            ]
          }.to_json
        }

        context 'when there is a function subject' do
          let(:test) {
%q{
subject: aFunction
examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  arguments: [1, 4, 6]
  return: 29
}}
          let(:expected_code) { "things\nprogram {\n   return (aFunction(1,4,6))\n}\n" }

          it { expect(result).to eq expected_compilation }
        end

        context 'when there is a procedure subject' do
          let(:test) {
%q{
subject: AProcedure
examples:
- initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  arguments: [9]
}}
          let(:expected_code) { "things\nprogram {\n   AProcedure(9)\n}\n" }

          it { expect(result).to eq expected_compilation }
        end
      end
    end
  end
end
