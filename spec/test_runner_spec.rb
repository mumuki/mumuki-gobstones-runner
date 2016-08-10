require_relative 'spec_helper'

class DummyRenderer
  def render(json_result)
    json_result
  end
end

describe 'running' do
  let(:runner) { QsimTestHook.new }

  describe '#run!' do
    before { runner.renderer = DummyRenderer.new }
    let(:result) { runner.run!(file) }

    context 'when program finishes' do
      let(:file) { File.new 'spec/data/q1-ok.qsim' }
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
      let(:file) { File.new 'spec/data/syntax-error.qsim' }

      let(:expected_result) { 'Ha ocurrido un error en la linea 2 : MOV REGISTRY5, 0x0004' }

      it { expect(result[1]).to eq :errored  }
      it { expect(result[0]).to eq expected_result }
    end

    context 'when program fails with runtime error' do
      let(:file) { File.new 'spec/data/runtime-error.qsim' }

      let(:expected_result) { 'Una de las etiquetas utilizadas es invalida' }

      it { expect(result[1]).to eq :failed  }
      it { expect(result[0]).to eq expected_result }
    end
  end

  describe 'with HTML renderer' do
    context 'when program finishes' do
      let(:file) { File.new 'spec/data/q1-ok.qsim' }
      let(:html) { runner.run!(file)[0] }

      it { expect(html).to include 'R3' }
      it { expect(html).to include '0007' }
    end
  end
end
