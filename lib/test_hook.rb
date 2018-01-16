class GobstonesTestHook < Mumukit::Defaults::PrecompileHook
  def run!(request)
    output, status = request.result

    if status == :passed
      request.batch.run_tests! output
    else
      request.result
    end
  end
end
