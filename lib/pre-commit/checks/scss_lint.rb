class ScssLint
  attr_accessor :staged_files, :error_message

  BAD_FORMATTING_PATTERN = ':  |:[^;]+$|;;$|^.+[^ ]{|,[^ ]| 0px| 0em| 0%'

  def self.call
    check = new
    check.staged_files = Utils.staged_files('.')
    result = check.run

    if !result
      $stderr.puts check.error_message
      $stderr.puts
      $stderr.puts 'pre-commit: You can bypass this check using `git commit -n`'
      $stderr.puts
    end

    result
  end

  def run
    # There is nothing to check
    return true if staged_scss_files.empty?

    if detected_bad_code?
      @error_message = "pre-commit: detected scss code convention violation:\n"
      @error_message += violations[:lines]

      @passed = false
    else
      @passed = true
    end

    @passed
  end

  def detected_bad_code?
    violations[:success]
  end

  def violations
    @violations ||= begin
      lines = `#{Utils.grep} '#{BAD_FORMATTING_PATTERN}' #{staged_scss_files}`
      success = $?.exitstatus == 0

      { :lines => lines, :success => success }
    end
  end

  def staged_scss_files
    @staged_scss_files ||= staged_files.split(' ').select do |file|
      File.extname(file) =~ /\.s?css$/
    end.join(' ')
  end
end
