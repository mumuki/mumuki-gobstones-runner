require_relative './spec_helper'

describe 'metatest' do

  let(:result) { framework.test compilation, examples }
  let(:options) { { show_initial_board: false, check_head_position: true } }
  let(:checker) { Gobstones::Checker.new(options) }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: checker,
                                     runner: Gobstones::MultipleExecutionsRunner.new
  end
  let(:dummy_view_board) do
    { head: { x: 0, y: 0 }, width: 3, height: 3, table: {
      json: [[{}, {}, {}], [{}, {}, {}], [{}, {}, {}]]
    } }
  end
  let(:dummy_gbb) do
    'GBB/1.0\r\nsize 1 1\r\nhead 0 0\r\n'
  end
  let(:exit_status) { { type: "Number", value: 29 } }
  let(:compilation_boom) do
    [
      {
        status: "runtime_error",
        result: {
          initialBoard: dummy_view_board,
          extraBoard: dummy_view_board,
          finalBoardError: {
            on: {
              range: {
                start: {
                  row: 1,
                  column: 2
                }
              }
            },
            message: "Blah",
            reason: {
              code: "no_stones"
            }
          }
        }
      }
    ]
  end

  before { allow(Mumukit).to receive(:runner_url) { 'http://gobstones.runners.mumuki.io' } }

  def board_with_stones(headX, headY, altered_cell: {})
    {
      head: { x: headX, y: headY },
      width: 3,
      height: 3,
      table: {
        gbb: dummy_gbb,
        json: [
          [{}, {}, {}],
          [{}, {}, {}],
          [{ black: 1, green: 1 }, altered_cell, {}]
        ]
      },
      returnValue: exit_status
    }
  end

  def compilation_board(initial: dummy_view_board, expected: dummy_view_board, actual: board_with_stones(0, 1))
    [
      {
        status: "passed",
        result: {
          extraBoard: expected,
          initialBoard: initial,
          finalBoard: actual
        }
      }
    ]
  end

  describe 'final_board postcondition' do

    let(:examples) {
      [{
         id: 0,
         postconditions: {
           final_board: dummy_gbb
         }
       }]
    }

    context 'when the program returns a final board' do
      context 'when passes with check_head_position=false' do
        let(:compilation) {
          compilation_board expected: board_with_stones(5, 5)
        }

        let(:options) { { show_initial_board: false, check_head_position: false } }

        it { expect(result[0][0][1]).to eq :passed }
      end

      describe 'when check_head_position=true' do

        context 'no movement nor state change was expected, but she moved' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 2), actual: board_with_stones(0, 0) }
          it { expect(result[0][0][1]).to eq :failed }
          it { expect(checker.warnings).to include :no_movement_nor_state_change_expected_but_moved }
        end

        context 'movement expected, but she didn\'t move movement' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 3), actual: board_with_stones(2, 2) }
          it { expect(result[0][0][1]).to eq :failed }
          it { expect(checker.warnings).to include :only_movement_expected_but_did_not_move }
        end

        context 'movement expected, but she didn\'t move properly' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 3), actual: board_with_stones(3, 2) }
          it { expect(result[0][0][1]).to eq :failed }
          it { expect(checker.warnings).to include :only_movement_expected_but_moved_in_wrong_direction }
        end

        context 'state changes were expected, but didn\'t change properly' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 2, altered_cell: {blue: 2}), actual: board_with_stones(2, 2, altered_cell: {red: 1}) }

          it { expect(result[0][0][1]).to eq :failed }
          it { expect(result[0][0][2]).to include "different board was obtained" }
          it { expect(result[0][0][2]).to_not include "head doesn't match" }
          it { expect(checker.warnings).to include :state_changes_expected_but_changed_improperly }
        end

        context 'state changes were expected, but didn\'t change' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 2, altered_cell: {blue: 2}), actual: board_with_stones(2, 2) }

          it { expect(result[0][0][1]).to eq :failed }
          it { expect(result[0][0][2]).to include "different board was obtained" }
          it { expect(result[0][0][2]).to_not include "head doesn't match" }
          it { expect(checker.warnings).to include :state_changes_expected_but_did_not_change }
        end

        context 'passed' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 2, altered_cell: {blue: 2}), actual: board_with_stones(2, 2, altered_cell: {blue: 2}) }

          it { expect(result[0][0][1]).to eq :passed }
          it { expect(result[0][0][2]).to_not include "different board was obtained" }
          it { expect(result[0][0][2]).to_not include "head doesn't match" }
          it { expect(checker.warnings).to be_empty }
        end

        context 'state changes were expected and ocurred, but head does not match' do
          let(:compilation) { compilation_board initial: board_with_stones(2, 2), expected: board_with_stones(2, 2, altered_cell: {blue: 2}), actual: board_with_stones(2, 2, altered_cell: {blue: 2}) }

          it { expect(result[0][0][1]).to eq :passed }
          it { expect(result[0][0][2]).to_not include "different board was obtained" }
          it { expect(result[0][0][2]).to include "head doesn't match" }
          it { expect(checker.warnings).to include :head_position_not_match }
        end

      end


    end

    context 'when the program does boom' do
      let(:compilation) { compilation_boom }

      it { expect(result[0][0][1]).to eq :failed }
      it { expect(result[0][0][2]).to include "The program did BOOM." }
    end

  end

  describe 'error postcondition' do

    let(:examples) {
      [{
        id: 0,
        postconditions: {
          error: "no_stones"
        }
      }]
    }

    context 'when the program returns a final board' do
      let(:compilation) { compilation_board }

      it { expect(result[0][0][1]).to eq :failed }
      it { expect(result[0][0][2]).to include "The program was expected to BOOM but a final board was obtained." }
    end

    context 'when the program does boom' do
      let(:compilation) { compilation_boom }

      context 'with the same reason as expected' do
        it { expect(result[0][0][1]).to eq :passed }
      end

      context 'with another reason' do
        let(:examples) {
          [{
              id: 0,
              postconditions: {
                error: "out_of_board"
              }
           }]
        }

        it { expect(result[0][0][1]).to eq :failed }
        it { expect(result[0][0][2]).to include "The program was expected to fail by <strong>out of board</strong>, but it failed by another reason." }
      end

    end

  end

  describe 'return postcondition' do

    let(:examples) {
      [{
        id: 0,
        postconditions: {
          return: 29
        }
      }]
    }

    context 'when the program returns a final board' do
      let(:compilation) { compilation_board }

      context 'when passes with equal value' do
        it { expect(result[0][0][1]).to eq :passed }
      end

      context 'when fails by no return value' do
        let(:exit_status) { nil }

        it { expect(result[0][0][1]).to eq :failed }
        it { expect(result[0][0][2]).to include "<strong>29</strong> was expected but no value was obtained." }
      end

      context 'when fails by different values' do
        let(:examples) {
          [{
            id: 0,
            postconditions: {
              return: 11
            }
          }]
        }

        it { expect(result[0][0][1]).to eq :failed }
        it { expect(result[0][0][2]).to include "<strong>11</strong> was expected but <strong>29</strong> was obtained." }
      end

    end

    context 'when the program does boom' do
      let(:compilation) { compilation_boom }

      context 'when fails because the program did boom' do
        it { expect(result[0][0][1]).to eq :failed }
        it { expect(result[0][0][2]).to include "The program did BOOM." }
      end
    end

  end

end
