require_relative 'spec_helper'

describe GobstonesExpectationsHook do
  def req(expectations, content, warnings: nil)
    GobstonesPrecompileHook.new.compile(
      OpenStruct.new(expectations: expectations, content: content, test: %q{
examples:
- initial_board: |
    GBB/1.0
    size 1 1
    head 0 0
})).tap { |it| it.precompiled_batch.warnings.push(*warnings) if warnings }
  end

  def compile_and_run(request)
    runner.run!(runner.compile(request))
  end

  let(:runner) { GobstonesExpectationsHook.new(mulang_path: './bin/mulang') }
  let(:result) { compile_and_run(request) }
  let(:request) { req(expectations, code) }

  context 'basic expectations' do
    let(:code) { 'program { foo := 1 }' }
    let(:expectations) do
      [{binding: '*', inspection: 'Assigns:foo'}]
    end

    it { expect(result).to eq([{expectation: expectations[0], result: true}]) }
  end

  context 'multiple basic expectations' do
    let(:code) { 'program { bar := 1 }' }
    let(:expectations) do
      [{binding: '*', inspection: 'Not:Assigns:foo'}, {binding: 'foo', inspection: 'Uses:bar'}]
    end

    it { expect(result).to eq([{expectation: expectations[0], result: true},
                               {expectation: expectations[1], result: false}]) }
  end


  context 'with warnings' do
    let(:request) { req(expectations, code, warnings: [:state_changes_expected_and_ocurred_but_head_did_not_match]) }
    let(:code) { 'program { foo := 1 }' }
    let(:expectations) { [] }

    it { expect(result).to eq([{expectation: {binding: "*", inspection: "HeadPositionMatch"}, result: false}]) }
  end

end
