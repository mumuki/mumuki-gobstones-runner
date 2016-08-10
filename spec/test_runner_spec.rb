require_relative './spec_helper'
require_relative './data/fixture'

class DummyRenderer
  def render(json_result)
    json_result
  end
end

describe 'running' do
  include Fixture

  def mk_request(content, extra, test)
    OpenStruct.new(content: content, extra: extra, test: test)
  end

  let(:runner) { QsimTestHook.new }

  describe '#compile_file_content' do
    let(:request) { mk_request 'ADD R1, R2', 'MOV R1, 0x00FA', {examples: []} }
    let(:result) { runner.compile_file_content request }

    it { expect(result).to eq "MOV R1, 0x00FA\nADD R1, R2" }
  end

  describe '#run!' do
    before { runner.renderer = DummyRenderer.new }
    let(:file) { runner.compile(mk_request content, '', test) }
    let(:test) { {examples: examples} }
    let(:examples) { [] }
    let(:result) { runner.run!(file) }

    context 'when program finishes' do
      let(:content) { q1_ok_program }

      let(:expected_result) {{
        special_records: { PC: '0005', SP: 'FFEF', IR: '28E5 ' },
        flags: { N: 0, Z: 0, V: 0, C: 0 },
        records: {
          R0: '0000', R1: '0000', R2: '0000', R3: '0007',
          R4: '0000', R5: '0004', R6: '0000', R7: '0000'
        }
      }}

      it { expect(result[1]).to eq :passed }
      it { expect(result[0]).to eq expected_result }
    end

    context 'when program fails with syntax error' do
      let(:content) { syntax_error_program }
      let(:expected_result) { 'Ha ocurrido un error en la linea 2 : MOV REGISTRY5, 0x0004' }

      it { expect(result[1]).to eq :errored  }
      it { expect(result[0]).to eq expected_result }
    end

    context 'when program fails with runtime error' do
      let(:content) { runtime_error_program }
      let(:expected_result) { 'Una de las etiquetas utilizadas es invalida' }

      it { expect(result[1]).to eq :failed  }
      it { expect(result[0]).to eq expected_result }
    end

    context 'HTML representation' do
      before { runner.renderer = Qsim::HtmlRenderer.new }
      let(:content) { q1_ok_program }
      let(:html) { result[0] }

      it { expect(html).to include 'R3' }
      it { expect(html).to include '0007' }
    end
  end
end
