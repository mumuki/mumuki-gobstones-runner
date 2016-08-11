class QsimMetadataHook < Mumukit::Hook
  def metadata
    {
      language: {
        name: 'qsim',
        icon: {type: 'devicon', name: 'qsim'},
        version: 'v0.2.2',
        extension: 'qsim',
        ace_mode: 'assembly_x86',
        graphic: true
      },
      test_framework: {
        name: 'metatest',
        test_extension: 'yml'
      }
    }
  end
end