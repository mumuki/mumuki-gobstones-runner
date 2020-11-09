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

    context 'procedure has no closing curly brace before program' do
      let(:content) { %q{ procedure Foo() \{
                            Bar()
                            program{}
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_before_closing_procedure_when_program)}</li>\n</ul>") }
    end

    context 'procedure has no closing curly brace when no program' do
      let(:content) { %q{ procedure Foo() \{
                            Bar()
                        }
      }
      let(:result) { ['<pre>[4:1]: Se esperaba un comando.
Se encontró: la palabra clave "program".</pre>'] }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_before_closing_procedure_when_no_program)}</li>\n</ul>") }
    end

    context 'surplus closing brace' do
      let(:content) { %q{ procedure Foo() {
                            repeat (5) {}
                            Bar() }
                          \}
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:surplus_closing_brace, line: 4)}</li>\n</ul>") }
    end

    context 'upper procedure typo' do
      let(:content) { %q{ Procedure Foo() {
                            bar()
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_procedure_typo)}</li>\n</ul>") }
    end

    context 'upper program typo' do
      let(:content) { %q{ Program {
                            bar()
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_program_typo)}</li>\n</ul>") }
    end

    context 'upper function typo' do
      let(:content) { %q{ Function f() {
                          bar()
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_function_typo)}</li>\n</ul>") }
    end

    context 'missing closing brace after procedure' do
      let(:content) { %q{ procedure Foo(){
                            Bar()
                          procedure Lol()\{
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:missing_closing_brace_after_procedure, line: 3)}</li>\n</ul>") }
    end

    context 'lower mover typo' do
      let(:content) { %q{ procedure Foo() {
                          mover(Oeste)
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_mover_typo)}</li>\n</ul>") }
    end

    context 'lower poner typo' do
      let(:content) { %q{ procedure Foo() {
                          poner   (Verde)
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_poner_typo)}</li>\n</ul>") }
    end

    context 'lower sacar typo' do
      let(:content) { %q{ procedure Foo() {
                          sacar (Verde)
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_sacar_typo)}</li>\n</ul>") }
    end
  end
end

