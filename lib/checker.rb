module Gobstones
  class Checker < Mumukit::Metatest::Checker
    def initialize(options)
      @options = options
    end

    def check_final_board(output, expected)
      status = output[:status]
      result = output[:result]

      fail_with status: :check_final_board_failed_unexpected_boom,
                result: {
                  initial: result[:initialBoard],
                  expected: result[:extraBoard],
                  actual: :boom,
                  reason: result[:finalBoardError]
                } if status == :runtime_error

      actual = result[:finalBoard][:table][:gbb]

      fail_with status: :check_final_board_failed,
                result: {
                  initial: result[:initialBoard],
                  expected: result[:extraBoard],
                  actual: result[:finalBoard]
                } if clean(actual) != clean(expected)
    end

    def check_error(output, expected)
      status = output[:status]
      result = output[:result]

      fail_with status: :check_error_failed_expected_boom,
                result: {
                  initial: result[:initialBoard],
                  expected: :boom,
                  final: result[:finalBoard]
                } if status == :passed

      code = result[:finalBoardError][:reason][:code]
      fail_with status: :check_error_failed_another_reason,
                result: {
                  reason: result[:finalBoardError],
                  expected_code: expected
                } if code != expected
    end

    # // TODO postconditions que faltan: return

    def render_success_output(output)
      status = output[:status]
      result = output[:result]

      renderer.render_success(
        { initial: result[:initialBoard] }.merge(
          if status == :passed
            { final: result[:finalBoard] }
          else
            { final: :boom.to_s, reason: result[:finalBoardError] } # // TODO: deduplicar esta lógica
          end
        )
      )
    end

    def render_error_output(output, error)
      report = error.parse_as_json
      renderer.send "render_error_#{report[:status]}", report[:result]
    end

    private

    def fail_with(error)
      fail JSON.generate(error)
    end

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new(@options)
    end

    def clean(gbb)
      clean_gbb = gbb.gsub /\r|\n/, ""

      if @options[:check_head_position]
        clean_gbb
      else
        clean_gbb.gsub /head \d+ \d+/, ""
      end
    end
  end
end
