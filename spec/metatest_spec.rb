require_relative './spec_helper'

class TextChecker < Mumukit::Metatest::Checker
  def check_include(value, arg)
    fail "expected '#{value}' to include '#{arg}'" unless value.include? arg
  end

  def check_equal(value, arg)
    fail "expected '#{value}' to equal '#{arg}'" unless value == arg
  end
end


describe 'metatest' do
  let(:result) { framework.test compilation, examples }

  describe 'qsim' do
    let(:framework) do
      Mumukit::Metatest::Framework.new checker: Qsim::Checker.new,
                                       runner: Mumukit::Metatest::IdentityRunner.new
    end
    let(:compilation) do
      {
          special_records: {PC: '0005', SP: 'FFEF', IR: '28E5 '},
          flags: {N: 0, Z: 0, V: 0, C: 0},
          records: {
              R0: '0000', R1: '0000', R2: '0000', R3: '0000',
              R4: '0003', R5: '0004', R6: '0000', R7: '0000'
          }
      }
    end
    context 'simple qsim test' do
      let(:examples) {
        [{
             name: 'R3 is 0003',
             preconditions: [],
             operation: :run,
             postconditions: {compare: {R3: '0003'}}
         }]
      }
      it { expect(result).to eq [[['R3 is 0003', :failed, 'R3 should be 0003, but was 0000']]] }
    end

    context 'simple qsim test with implicit preconditions and operation' do
      let(:examples) {
        [{
             name: 'R3 is 0003',
             postconditions: {compare: {R3: '0003'}}
         }]
      }
      it { expect(result).to eq [[['R3 is 0003', :failed, 'R3 should be 0003, but was 0000']]] }
    end

    context 'simple qsim test with explicit preconditions' do
      let(:examples) {
        [{
             name: 'R3 is 0003',
             preconditions: {R3: '0001', R4: '0003'},
             postconditions: {compare: {R3: '0003'}}
         },
         {
             name: 'R4 is 0003',
             preconditions: {R3: '0001', R4: '0003'},
             postconditions: {compare: {R4: '0003'}}
         }]
      }
      it { expect(result).to eq [[['R3 is 0003', :failed, 'R3 should be 0003, but was 0000'],
                                  ['R4 is 0003', :passed, nil]]] }
    end
  end


  context 'simple text test' do
    let(:framework) do
      Mumukit::Metatest::Framework.new checker: TextChecker.new,
                                       runner: Mumukit::Metatest::IdentityRunner.new
    end

    let(:examples) {
      [{
           name: 'has passion',
           postconditions: {include: 'passion'}
       }]
    }

    context 'pass' do
      let(:compilation) { 'escualo is passion' }
      it { expect(result).to eq [[['has passion', :passed, nil]]] }
    end
    context 'fails' do
      let(:compilation) { 'escualo is poison' }
      it { expect(result).to eq [[['has passion', :failed, "expected 'escualo is poison' to include 'passion'"]]] }
    end
  end
end

