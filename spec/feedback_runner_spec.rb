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
    let(:request) { req(content) }

    context 'program has an upper name and braces' do
      let(:content) { 'program Foo(){}' }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_has_a_name, name: 'Foo')}</li>\n</ul>") }
    end

    context 'program has a lower name and no braces' do
      let(:content) { 'program foo' }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_has_a_name, name: 'foo')}</li>\n</ul>") }
    end

    context 'program has no opening curly brace' do
      let(:content) { %q{ program
                            foo()
                            foo()
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_has_no_opening_curly_brace)}</li>\n</ul>") }
    end
  end
end

