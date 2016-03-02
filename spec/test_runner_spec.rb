require_relative 'spec_helper'

describe 'running' do
  let(:runner) { TestHook.new('runqsim_command' => 'java -jar -Djava.system.class.loader=com.uqbar.apo.APOClassLoader ./bin/QSim.jar') }

  describe '#run' do
    context 'when program finishes' do
      let(:file) { File.new 'spec/data/passed/programaqsimpass.qsim' }
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
      it { expect(result[0]).to include expected_result_json }
    end
  end
end
