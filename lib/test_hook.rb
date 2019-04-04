class GobstonesTestHook < Mumukit::Defaults::TestHook
  def run!(request)
    output, status = request.result

    if request.batch.options[:interactive]
      ['', :passed]
    elsif status == :passed
      request.batch.run_tests! output
    else
      request.result
    end
  end
end
