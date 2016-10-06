require_relative './spec_helper'

describe 'metatest' do
  let(:result) { framework.test compilation, examples }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: Qsim::Checker.new,
                                     runner: Qsim::MultipleExecutionsRunner.new
  end
  let(:compilation) do
    [{
        id: 1,
        special_records: {PC: '0005', SP: 'FFEF', IR: '28E5 '},
        flags: {N: 0, Z: 0, V: 0, C: 0},
        records: {
            R0: '0000', R1: '0000', R2: '0000', R3: '0000',
            R4: '0003', R5: '0004', R6: '0000', R7: '0000'
        }
    }]
  end

  describe 'equal postcondition' do
    context 'when fails' do
      let(:examples) {
        [{
            id: 1,
            name: 'R3 is 0003',
            postconditions: {equal: {R3: '0003'}}
         }]
      }
      it { expect(result[0][0]).to include 'R3 is 0003', :failed }
      it { expect(result[0][0][2]).to include '<b>R3</b> should be <b>0003</b>, but was <b>0000</b>' }
    end

    context 'when passes' do
      let(:examples) {
        [{
            id: 1,
            name: 'R3 is 0000',
            postconditions: {equal: {R3: '0000'}}
         }]
      }
      it { expect(result[0][0]).to include 'R3 is 0000', :passed }
    end
  end
end
