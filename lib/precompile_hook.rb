class GobstonesPrecompileHook < Mumukit::Templates::FileHook
  attr_accessor :batch

  DEFAULT_TIMEOUT = 2

  structured true
  isolated false

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gobstones-cli --batch #{filename} #{locale_argument} #{timeout_argument}"
  end

  def locale_argument
    "--language #{@locale}" if @locale
  end

  def timeout_argument
    "--timeout " + timeout.to_s
  end

  def timeout
    (ENV['MUMUKI_GOBSTONES_TIMEOUT'] || DEFAULT_TIMEOUT).to_i * 1000
  end

  def compile(request)
    add_missing_headers! request
    @locale = request[:locale]
    file = super request

    struct request.to_h.merge batch: @batch,
                              result: run!(file)
  end

  def add_missing_headers!(request)
    request.test.gsub! /(.*(initial_board|final_board): \|.*\n)(?!.*GBB\/1\.0.*)/, "\\1    GBB/1.0\\3\n"
  end

  def compile_file_content(request)
    @batch = Gobstones::BatchParser.parse(request)
    @batch.to_json
  end

  def post_process_file(_file, result, status)
    if status == :passed
      result = result.parse_as_json
      status = :aborted if is_timeout? result and !expects_timeout?
    end

    [result, status]
  end

  private

  def expects_timeout?
    @batch.options[:expect_endless_while] || @batch.examples.any? { |it| it[:postconditions][:error] == 'timeout' }
  end

  def is_timeout?(result)
    result[0]&.dig(:result, :finalBoardError, :reason, :code) === 'timeout'
  end
end
