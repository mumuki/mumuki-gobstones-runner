class GobstonesPrecompileHook < Mumukit::Templates::FileHook
  attr_accessor :batch

  structured true
  isolated true

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gobstones-cli --batch #{filename}"
  end

  def compile(request)
    add_missing_headers! request
    file = super request

    struct request.to_h.merge batch: @batch,
                              result: run!(file)
  end

  def add_missing_headers!(request)
    request.test.gsub! /(.*(initial_board|final_board).*\n)(?!.*GBB\/1\.0.*)/, "\\1    GBB/1.0\\3\n"
  end

  def compile_file_content(request)
    @batch = Gobstones::BatchParser.parse(request)
    @batch.to_json
  end

  def post_process_file(_file, result, status)
    [result.parse_as_json, status]
  end
end
