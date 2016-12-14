require_relative './spec_helper'

describe 'metatest' do

  let(:result) { framework.test compilation, examples }
  let(:options) { { show_initial_board: false, check_head_position: true } }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: Gobstones::Checker.new(options),
                                     runner: Gobstones::MultipleExecutionsRunner.new
  end
  let(:dummy_view_board) do
    { x: 0, y: 0, sizeX: 3, sizeY: 3, table: {
      json: []
    } }
  end

  let(:compilation_board) do
    [
      {
        status: "passed",
        result: {
          extraBoard: dummy_view_board,
          initialBoard: dummy_view_board,
          finalBoard: {
            x: 0,
            y: 1,
            sizeX: 3,
            sizeY: 3,
            table: {
              gbb: "GBB/1.0\r\nsize 3 3\r\nhead 1 0\r\n",
              json: []
            }
          }
        }
      }
    ]
  end

  let(:compilation_boom) do
    [
      {
        status: "runtime_error",
        result: {
          initialBoard: dummy_view_board,
          extraBoard: dummy_view_board,
          finalBoardError: {
            on: { blah: :bleh },
            message: "Blah",
            reason: {
              code: "no_stones"
            }
          }
        }
      }
    ]
  end

  describe 'final_board postcondition' do

    context 'when the program returns a final board' do

      let(:compilation) { compilation_board }

      context 'when passes with check_head_position=true' do
        let(:examples) {
          [{
            id: 0,
            postconditions: {
              final_board: "GBB/1.0\r\nsize 3 3\r\nhead 1 0\r\n"
            }
          }]
        }

        it { expect(result[0][0]).to include :passed }
      end

      context 'when passes with check_head_position=false' do
        let(:options) { { show_initial_board: false, check_head_position: false } }

        let(:examples) {
          [{
              id: 0,
              postconditions: {
                final_board: "GBB/1.0\r\nsize 3 3\r\nhead 5 5\r\n"
              }
           }]
        }

        it { expect(result[0][0]).to include :passed }
      end

      context 'when fails by different boards' do
        let(:examples) {
          [{
              id: 0,
              postconditions: {
                final_board: "GBB/1.0\r\nsize 3 3\r\nhead 2 2\r\n"
              }
           }]
        }

        it { expect(result[0][0]).to include :failed }
        it { expect(result[0][0][2]).to include "Expected final board" }
      end

    end

    context 'when the program returns a final board' do

      let(:compilation) { compilation_boom }

      context 'when fails because the program did boom' do
        let(:examples) {
          [{
              id: 0,
              postconditions: {
                final_board: "GBB/1.0\r\nsize 3 3\r\nhead 1 0\r\n"
              }
           }]
        }

        it { expect(result[0][0]).to include :failed }
        it { expect(result[0][0][2]).to include "A final board was expected but the program did BOOM" }
      end

    end

  end

  describe 'error postcondition' do

    context 'when the program returns a final board' do

      let(:compilation) { compilation_board }

      let(:examples) {
        [{
          id: 0,
          postconditions: {
            error: "no_stones"
          }
        }]
      }

      it { expect(result[0][0]).to include :failed }
      it { expect(result[0][0][2]).to include "The program was expected to BOOM but a final board was obtained." }

    end

    context 'when the program does boom' do

      let(:compilation) { compilation_boom }

      context 'with the same reason as expected' do
        let(:examples) {
          [{
              id: 0,
              postconditions: {
                error: "no_stones"
              }
           }]
        }

        it { expect(result[0][0]).to include :passed }
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

        it { expect(result[0][0]).to include :failed }
        it { expect(result[0][0][2]).to include "The program was expected to fail by <strong>Out of board</strong>, but it failed by another reason." }
      end

    end

  end

end
