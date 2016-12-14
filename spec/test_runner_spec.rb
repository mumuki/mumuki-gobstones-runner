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
- title: Un nombre
  initial_board: |
    GBB/1.0
    size 3 3
    head 0 0
  final_board: |
    GBB/1.0
    size 3 3
    head 0 1
}}

    let(:request) { req content, extra, test }
    let!(:result) { runner.compile_file_content request }

    context 'generates a JSON with the batch request' do
      let(:expected_compiled_code) {
        JSON.generate([
          initialBoard: "GBB/1.0\nsize 3 3\nhead 0 0\n",
          code: "procedure PonerDosRojas() {\n  Poner(Rojo)\n  Poner(Rojo)\n}\nprogram {\n  PonerDosRojas()\n}",
          extraBoard: "GBB/1.0\nsize 3 3\nhead 0 1\n"
        ])
      }

      it { expect(result).to eq expected_compiled_code }
    end

    context 'parses the examples' do
      let(:expected_example) {
        {
          id: 0,
          title: "Un nombre",
          preconditions: {
            initial_board: "GBB/1.0\nsize 3 3\nhead 0 0\n",
          },
          postconditions: {
            final_board: "GBB/1.0\nsize 3 3\nhead 0 1\n"
          }
        }
      }

      it { expect(runner.options).to eq({
        show_initial_board: true,
        check_head_position: true,
        subject: nil
      }) }
      it { expect(runner.examples).to eq [expected_example] }
    end
  end
end
