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

    context 'when program finishes' do
      let(:file) { File.new 'spec/data/q1-ok.qsim' }
      let(:result) { runner.run!(file) }
      let(:expected_result_json) {'{
  "special_records": {
    "PC": "0005",
    "SP": "FFEF",
    "IR": "28E5 "
  },
  "flags": {
    "N": 0,
    "Z": 0,
    "V": 0,
    "C": 0
  },
  "records": {
    "R0": "0000",
    "R1": "0000",
    "R2": "0000",
    "R3": "0007",
    "R4": "0000",
    "R5": "0004",
    "R6": "0000",
    "R7": "0000"
  }
}
'}
      it { expect(result[1]).to eq :passed }
      it { expect(result[0]).to eq expected_result_json }
    end
  end

  describe 'with HTML renderer' do
    context 'when program finishes' do
      let(:file) { File.new 'spec/data/q1-ok.qsim' }
      let(:html) { runner.run!(file)[0] }

      it { expect(html).to include '<th>R3</th>' }
      it { expect(html).to include '<td>0007</td>' }
    end
  end
end
