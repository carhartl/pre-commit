require 'minitest_helper'
require 'pre-commit/checks/closure_linter'

class ClosureLinterTest < MiniTest::Unit::TestCase

  def test_should_detect_a_violation
    check = ClosureLinter.new
    check.staged_files = test_filename('wrong_closure_linter.js')
    assert check.detected_bad_code?, 'detect bad code'
  end

  def test_does_not_detect_bad_code_in_a_valid_file
    check = ClosureLinter.new
    check.staged_files = test_filename('valid_closure_linter.js')
    assert !check.detected_bad_code?, 'should pass valid js'
  end

  def test_should_run_with_valid_file
    check = ClosureLinter.new
    check.staged_files = test_filename('valid_closure_linter.js')
    assert check.run, 'should run valid js'
  end

  def test_check_should_pass_if_staged_file_list_is_empty
    check = ClosureLinter.new
    check.staged_files = ''
    assert check.run
  end

  def test_should_skip_non_js_files
    check = ClosureLinter.new
    check.staged_files = test_filename('wrong_closure_linter.txt')
    assert check.run
  end

end
