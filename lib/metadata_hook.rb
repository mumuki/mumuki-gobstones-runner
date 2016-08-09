class QSimMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'qsim',
        icon: {type: 'devicon', name: 'qsim'},
        version: 'v0.2.0',
        extension: 'qsim',
        ace_mode: 'assembly_x86'
    }
}
  end
end