require_relative './spec_helper'

describe 'running' do
  def req(content, extra, test = 'examples: [{}]')
    struct content: content.strip, extra: extra.strip, test: test
  end

  let(:runner) { GobstonesTestHook.new }

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
- title: BOOM with 1x1
  initial_board: |
    GBB/1.0
    size 1 1
    head 0 0
  error: out_of_board
}}

    let(:request) { req content, extra, test }
    let!(:result) { runner.compile_file_content request }

    context 'generates a JSON with the batch request' do
      let(:expected_code) { "procedure PonerDosRojas() {\n  Poner(Rojo)\n  Poner(Rojo)\n}\nprogram {\n  PonerDosRojas()\n}"}

      let(:expected_compilation) {
        JSON.generate([
          {
            initialBoard: "GBB/1.0\nsize 3 3\nhead 0 0\n",
            code: expected_code,
            extraBoard: "GBB/1.0\nsize 3 3\nhead 0 1\n"
          },
          {
            initialBoard: "GBB/1.0\nsize 1 1\nhead 0 0\n",
            code: expected_code
          }
        ])
      }

      it { expect(result).to eq expected_compilation }
    end

    context 'parses the examples' do
      let(:expected_examples) {
        [
          {
            id: 0,
            title: "A name",
            preconditions: {
              initial_board: "GBB/1.0\nsize 3 3\nhead 0 0\n",
            },
            postconditions: {
              final_board: "GBB/1.0\nsize 3 3\nhead 0 1\n"
            }
          },
          {
            id: 1,
            title: "BOOM with 1x1",
            preconditions: {
              initial_board: "GBB/1.0\nsize 1 1\nhead 0 0\n",
            },
            postconditions: {
              error: "out_of_board"
            }
          }
        ]
      }

      it { expect(runner.options).to eq({
        show_initial_board: true,
        check_head_position: true,
        subject: nil
      }) }
      it { expect(runner.examples).to eq expected_examples }
    end
  end
end
