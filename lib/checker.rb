module Gobstones
  class Checker < Mumukit::Metatest::Checker
    attr_reader :warnings

    include Gobstones::WithRenderer

    def initialize(options)
      @options = options
      @warnings = []
    end

    def check_final_board(output, expected)
      status = output[:status]
      result = output[:result]

      return if is_expected_timeout(result)
      assert_not_boom status, result

      initial_board = result[:initialBoard]
      expected_board = result[:extraBoard]
      actual_board = result[:finalBoard]
      boards_match = board_json(expected_board).eql? board_json(actual_board)
      headers_match = !@options[:check_head_position] || expected_board[:head].eql?(actual_board[:head])

      if !boards_match || !headers_match
        status = boards_match && !headers_match ?
          :check_final_board_failed_different_headers :
          :check_final_board_failed_different_boards

        if status == :check_final_board_failed_different_headers && board_changes_expected(initial_board, expected_board)
          @warnings << :head_position_not_match
        else
          fail_with status: status,
            result: {
              initial: initial_board,
              expected: expected_board,
              actual: actual_board
            }
        end
      end
    end

    def check_error(output, expected)
      status = output[:status]
      result = output[:result]

      return if is_expected_timeout(result)

      fail_with status: :check_error_failed_expected_boom,
                result: {
                  initial: result[:initialBoard],
                  expected: :boom,
                  final: result[:finalBoard]
                } if status.passed?

      reason_code = convert_known_reason_code result[:finalBoardError][:reason][:code]
      fail_with status: :check_error_failed_another_reason,
                result: {
                  reason: result[:finalBoardError],
                  expected_code: expected
                } if reason_code != expected
    end

    def check_return(output, expected)
      status = output[:status]
      result = output[:result]

      assert_not_boom status, result
      return_value = result[:finalBoard][:returnValue]

      fail_with status: :check_return_failed_no_return,
                result: {
                  initial: result[:initialBoard],
                  expected_value: expected
                } if return_value.nil?

      final_value = adapt_value return_value
      final_expected_value = expected

      if return_value[:type] == 'Number'
        final_value = final_value.to_s
        final_expected_value = final_expected_value.to_s
        # TODO: This is not ok but it's here for retrocompatibility issues.
      end

      fail_with status: :check_return_failed_different_values,
                result: {
                  initial: result[:initialBoard],
                  expected_value: expected,
                  actual_value: final_value
                } if final_value != final_expected_value
    end

    private

    def assert_not_boom(status, result)
      fail_with status: :check_failed_unexpected_boom,
                result: {
                  initial: result[:initialBoard],
                  expected: result[:extraBoard],
                  actual: :boom,
                  reason: result[:finalBoardError]
                } if status == :runtime_error
    end

    def is_expected_timeout(result)
      result[:finalBoardError] &&
      result[:finalBoardError][:reason][:code] == 'timeout' &&
      @options[:expect_endless_while]
    end

    def fail_with(error)
      fail error.to_json
    end

    def board_json(board)
      board[:table][:json]
    end

    def convert_known_reason_code(code)
      return "no_stones" if code == 'cannot-remove-stone'
      return "out_of_board" if code == 'cannot-move-to'
      return "unassigned_variable" if code == 'undefined-variable'
      return "wrong_argument_type" if has_wrong_argument_type? code
      return "wrong_arguments_quantity" if code.include? 'arity-mismatch'

      code
    end

    def has_wrong_argument_type?(code)
      code.match Regexp.union('type-mismatch', 'expected-value-of-type')
    end

    def adapt_value(return_value)
      type = return_value[:type]
      value = return_value[:value]

      return value.to_s.capitalize if type == 'Bool'

      value
    end

    def board_changes_expected(initial_board, expected_board)
      !board_json(initial_board).eql?(board_json(expected_board))
    end
  end
end
