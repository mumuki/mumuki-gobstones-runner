class GobstonesPrecompileHook < Mumukit::Templates::FileHook
  attr_accessor :batch

  structured true
  isolated true

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
    "--timeout #{(Mumukit.config.command_time_limit - 1) * 1000}"
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
      status = :aborted if is_timeout? result
    end

    [result, status]
  end

  private

  def is_timeout?(result)
    result[0]&.dig(:result, :finalBoardError, :reason, :code) === "timeout"
  end
end
