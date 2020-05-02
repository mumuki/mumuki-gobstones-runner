module Gobstones
  class TestClassifier
    attr_reader :error_class, :error_kind, :status

    def classify_boards!(initial, expected, actual)
      expected_head  = tag_2 expected, initial, :head
      expected_state = tag_2 expected[:table], initial[:table], :json

      actual_head  = tag_3 expected, actual, initial, :head
      actual_state = tag_3 expected[:table], actual[:table], initial[:table], :json

      @status, @error_class, @error_kind = classify expected_head, expected_state, actual_head, actual_state
    end

    private

    def classify(expected_head, expected_state, actual_head, actual_state)
      case [expected_head, expected_state, actual_head, actual_state]
      when [:initial,	:initial,	:other,	:expected] then [:failed, :no_movement_nor_state_change_expected_but_moved,     :check_final_board_failed_different_headers]
      when [:other,	:initial,	:initial,	:expected] then [:failed, :only_movement_expected_but_did_not_move,             :check_final_board_failed_different_headers]
      when [:other,	:initial,	:other,	:expected]   then [:failed, :only_movement_expected_but_moved_in_wrong_direction, :check_final_board_failed_different_headers]
      else
        if actual_state == :other                  then [:failed, :state_changes_expected_but_changed_improperly,       :check_final_board_failed_different_boards]
        elsif actual_state == :initial             then [:failed, :state_changes_expected_but_did_not_change,           :check_final_board_failed_different_boards]
        elsif [actual_head, actual_state] == [:expected, :expected] then [:passed, nil, nil]
        elsif expected_state == :other             then [:passed_with_warnings, :state_changes_expected_and_ocurred_but_head_did_not_match, :check_final_board_failed_different_headers]
        else raise "unhandled scenario #{[expected_head, expected_state, actual_head, actual_state]}"
        end
      end
    end

    def tag_2(expected, initial, key)
      expected[key] == initial[key] ? :initial : :other
    end

    def tag_3(expected, actual, initial, key)
      expected[key] == actual[key] ? :expected : tag_2(actual, initial, key)
    end
  end
end

