class GobstonesPrecompileHook < Mumukit::Defaults::TestHook
  def compile(request)
    struct request.to_h.merge batch: Gobstones::BatchParser.parse(request)
  end
end
