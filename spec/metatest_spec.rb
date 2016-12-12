require_relative './spec_helper'

describe 'metatest' do
  let(:result) { framework.test compilation, examples }
  let(:options) { { show_initial_board: false, check_head_position: false } }
  let(:framework) do
    Mumukit::Metatest::Framework.new checker: Gobstones::Checker.new(options),
                                     runner: Gobstones::MultipleExecutionsRunner.new
  end
  let(:dummy_view_board) do
    { x: 0, y: 0, sizeX: 3, sizeY: 3, table: {
      json: []
    } }
  end
  let(:compilation) do
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

  describe 'final_board postcondition' do
    context 'when passes' do
      let(:examples) {
        [{
            id: 0,
            initial_board: "GBB/1.0\r\nsize 3 3\r\nhead 0 0\r\n",
            postconditions: {
              final_board: "GBB/1.0\r\nsize 3 3\r\nhead 1 0\r\n"
            }
         }]
      }

      it { expect(result[0][0]).to include :passed }
    end

    context 'when fails' do
      let(:examples) {
        [{
            id: 0,
            initial_board: "GBB/1.0\r\nsize 3 3\r\nhead 0 0\r\n",
            postconditions: {
              final_board: "GBB/1.0\r\nsize 3 3\r\nhead 5 5\r\n"
            }
         }]
      }

      it { expect(result[0][0]).to include :failed }
    end
  end
end
