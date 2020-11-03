require_relative 'spec_helper'

describe GobstonesFeedbackHook do
  before { I18n.locale = :es }

  let(:feedback) { GobstonesFeedbackHook.new.run!(request, OpenStruct.new(test_results: result)) }

  describe 'when TestHook is run before FeedbackHook' do
    def req(content)
      GobstonesPrecompileHook.new.compile(struct content: content, test: %q{
examples:
- initial_board: |
    GBB/1.0
    size 1 1
    head 0 0
})
    end

    def compile_and_run(request)
      server.run!(server.compile(request))
    end

    let(:server) { GobstonesTestHook.new }
    let(:result) { compile_and_run(req(content)) }
  end
end

