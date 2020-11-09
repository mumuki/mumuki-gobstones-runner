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


      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_before_closing_structure_when_program, keyword: 'procedure')}</li>\n</ul>") }
    end

    context 'function has no closing curly brace when no program' do
      let(:content) { %q{ function foo() \{
                            Bar()
                        }
      }
      let(:result) { ['<pre>[4:1]: Se esperaba un comando.
Se encontró: la palabra clave "program".</pre>'] }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:program_before_closing_structure_when_no_program, keyword: 'function')}</li>\n</ul>") }
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

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_builtin_procedure_typo, lower: 'mover', upper: 'Mover')}</li>\n</ul>") }
    end

    context 'lower poner typo' do
      let(:content) { %q{ procedure Foo() {
                          poner   (Verde)
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_builtin_procedure_typo, lower: 'poner', upper: 'Poner')}</li>\n</ul>") }
    end

    context 'lower sacar typo' do
      let(:content) { %q{ procedure Foo() {
                          sacar (Verde)
                        }
                      }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:lower_builtin_procedure_typo, lower: 'sacar', upper: 'Sacar')}</li>\n</ul>") }
    end

    context 'upper HayBolitas typo' do
      let(:content) { %q{ function foo() {
                            if (HayBolitas(Verde)) {
                            }
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_builtin_function_typo, upper: 'HayBolitas', lower: 'hayBolitas')}</li>\n</ul>") }
    end

    context 'upper NroBolitas typo' do
      let(:content) { %q{ function foo() {
                            if (NroBolitas(Verde) > 2) {
                            }
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_builtin_function_typo, upper: 'NroBolitas', lower: 'nroBolitas')}</li>\n</ul>") }
    end

    context 'upper PuedeMover typo' do
      let(:content) { %q{ function foo() {
                            if (PuedeMover(Este)) {
                            }
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:upper_builtin_function_typo, upper: 'PuedeMover', lower: 'puedeMover')}</li>\n</ul>") }
    end

    context 'Roja typo' do
      let(:content) { %q{ procedure Foo() {
                            Poner(Roja)
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:color_typo, color: 'Roja', rectified_color: 'Rojo')}</li>\n</ul>") }
    end

    context 'Negra typo' do
      let(:content) { %q{ procedure Foo() {
                            Sacar  ( Negra)
                          }
                        }
      }

      it { expect(feedback).to eq("<ul>\n<li>#{I18n.t(:color_typo, color: 'Negra', rectified_color: 'Negro')}</li>\n</ul>") }
    end
  end
end

