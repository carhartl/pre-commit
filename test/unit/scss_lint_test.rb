require 'minitest_helper'
require 'pre-commit/checks/scss_lint'

class ScssLintTest < MiniTest::Unit::TestCase

  def test_should_detect_a_violation
    check = ScssLint.new
    check.staged_files = test_filename('wrong_scss.scss')
    assert check.detected_bad_code?, 'detect bad code'
  end

  def test_should_detect_all_violations
    check = ScssLint.new
    check.staged_files = test_filename('wrong_scss.scss')
    assert_equal 8, check.violations[:lines].split("\n").size
  end

  def test_does_not_detect_bad_code_in_a_valid_file
    check = ScssLint.new
    check.staged_files = test_filename('valid_scss.scss')
    assert !check.detected_bad_code?, 'should pass valid scss'
  end

  def test_should_run_with_valid_file
    check = ScssLint.new
    check.staged_files = test_filename('valid_scss.scss')
    assert check.run, 'should run valid scss'
  end

  def test_check_should_pass_if_staged_file_list_is_empty
    check = ScssLint.new
    check.staged_files = ''
    assert check.run
  end

  def test_guilty_file_in_error_message
    check = ScssLint.new
    check.staged_files = test_filename('wrong_scss.scss')
    check.run
    assert_match(/wrong_scss.scss/, check.error_message)
  end

  def test_should_skip_non_scss_files
    check = ScssLint.new
    check.staged_files = test_filename('wrong_scss.js')
    assert check.run
  end

end
