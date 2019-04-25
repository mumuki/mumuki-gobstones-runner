class GobstonesTestHook < Mumukit::Defaults::TestHook
  def run!(request)
    output, status = request.precompiled_result

    if request.precompiled_batch.options[:interactive]
      ['', :passed]
    elsif status.passed?
      request.precompiled_batch.run_tests! output
    else
      request.precompiled_result
    end
  end
end
