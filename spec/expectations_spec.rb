require_relative 'spec_helper'

describe GobstonesExpectationsHook do
  def req(expectations, content)
    GobstonesPrecompileHook.new.compile(
      OpenStruct.new(expectations: expectations, content: content, test: %q{
examples:
- initial_board: |
    GBB/1.0
    size 1 1
    head 0 0
}))
  end

  def compile_and_run(request)
    runner.run!(runner.compile(request))
  end

  let(:runner) { GobstonesExpectationsHook.new(mulang_path: './bin/mulang') }
  let(:result) { compile_and_run(req(expectations, code)) }

  context 'basic expectations' do
    let(:code) { 'program { foo := 1 }' }
    let(:expectations) do
      [{binding: '*', inspection: 'Assigns:foo'}]
    end

    it { expect(result).to eq([{expectation: expectations[0], result: true}]) }
  end

  context 'basic expectations with wildcard' do
    let(:code) { 'program { foo := nroBolitas(Rojo) }' }
    let(:expectations) do
      [{binding: '*', inspection: 'Uses:*'}]
    end

    it { expect(result).to eq([{expectation: expectations[0], result: true}]) }
  end

  context 'primitive expectations' do
    let(:code) { 'program { foo := 1 + 2 }' }
    let(:expectations) do
      [
        {binding: '*', inspection: 'UsesMath'},

        {binding: '*', inspection: 'UsesPlus'},
        {binding: '*', inspection: 'Uses:+'},
        {binding: '*', inspection: 'UsesMinus'},
        {binding: '*', inspection: 'Uses:-'},

        {binding: '*', inspection: 'Not:UsesPlus'},
        {binding: '*', inspection: 'Not:Uses:+'},

        {binding: '*', inspection: 'Not:UsesMinus'},
        {binding: '*', inspection: 'Not:Uses:-'},
      ]
    end

    it do
      expect(result).to eq([
        {expectation: expectations[0], result: true},

        {expectation: expectations[1], result: true},
        {expectation: expectations[1], result: true},

        {expectation: expectations[3], result: false},
        {expectation: expectations[3], result: false},

        {expectation: expectations[5], result: false},
        {expectation: expectations[5], result: false},

        {expectation: expectations[7], result: true},
        {expectation: expectations[7], result: true}
      ])
    end
  end

  context 'multiple basic expectations' do
    let(:code) { 'program { bar := 1 }' }
    let(:expectations) do
      [{binding: '*', inspection: 'Not:Assigns:foo'}, {binding: 'foo', inspection: 'Uses:bar'}]
    end

    it { expect(result).to eq([{expectation: expectations[0], result: true},
                               {expectation: expectations[1], result: false}]) }
  end
end
