require_relative './spec_helper'

module Mumukit::Metatest
  class Aborted < StandardError
  end

  class Errored < StandardError
  end

  class Failed < StandardError
  end

  class IdentityRunner
    def run(it, _example)
      it
    end
  end

  class Checker
    def check(value, example)
      example[:postconditions].map { |key, arg| partial key, value, arg, example }
    end

    def partial(key, value, arg, example)
      send "check_#{key}", value, arg
      [example[:name], :passed, nil]
    rescue => e
      [example[:name], :failed, e.message]
    end

    def fail(message)
      raise Failed, message
    end
  end

  class Framework
    def initialize(options={})
      @runner = options[:runner]
      @checker = options[:checker]
    end

    def test(compilation, examples)
      examples.map { |it| example(compilation, it) }
    rescue Aborted => e
      [e.message, :aborted]
    rescue Errored => e
      [e.message, :errored]
    end

    def example(compilation, example)
      @checker.check(@runner.run(compilation, example), example)
    end
  end
end

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
      Mumukit::Metatest::Framework.new checker: ,
                                       operations: {
                                           run: lambda { |it| run_qsim_code_here it }
                                       },
                                       assertions: {
                                           compare: lambda { |it| it[:result][:records][it[:record]] === it[:value] }
                                       }
    end
    context 'simple qsim test' do
      let(:compilation) { 'MOV R3, 0x0003' }
      let(:examples) {
        [{
             name: 'R3 is 0x0003',
             preconditions: [],
             operation: :run,
             postconditions: {compare: {R3: '0x0003'}}
         }]
      }
      it { expect(result).to eq [['R3 is 0x0003', :failed, 'R3 should be 0x0003, but was 0x0000']] }
    end

    context 'simple qsim test with implicit preconditions and operation' do
      let(:compilation) { 'MOV R3, 0x0003' }
      let(:examples) {
        [{
             name: 'R3 is 0x0003',
             postconditions: {compare: {R3: '0x0003'}}
         }]
      }
      it { expect(result).to eq [['R3 is 0x0003', :failed, 'R3 should be 0x0003, but was 0x0000']] }
    end

    context 'simple qsim test with explicit preconditions' do
      let(:compilation) { 'MOV R3, 0x0003' }
      let(:examples) {
        [{
             name: 'R3 is 0x0003',
             preconditions: {R3: '0x0001', R4: '0x0003'},
             postconditions: {compare: {R3: '0x0003'}}
         },
         {
             name: 'R4 is 0x0003',
             preconditions: {R3: '0x0001', R4: '0x0003'},
             postconditions: {compare: {R4: '0x0003'}}
         }]
      }
      it { expect(result).to eq [['R3 is 0x0003', :failed, 'R3 should be 0x0003, but was 0x0000'],
                                 ['R4 is 0x0003', :passed, nil]] }
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

