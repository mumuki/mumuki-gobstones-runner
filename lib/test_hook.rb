class GobstonesTestHook < Mumukit::Templates::FileHook
  attr_accessor :batch

  structured true
  isolated true

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gs-weblang-cli --batch #{filename}"
  end

  def compile_file_content(request)
    @batch = Gobstones::BatchParser.parse request
    @batch.to_json
  end

  def post_process_file(_file, result, status)
    output = result.parse_as_json

    if status == :passed
      @batch.run_tests! output
    else
      [output, status]
    end
  end

end
