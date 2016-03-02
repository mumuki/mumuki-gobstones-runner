class MetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'qsim',
        icon: {type: 'devicon', name: 'qsim'},
        extension: 'qsim',
        ace_mode: 'assembly_x86'
    }
}
  end
end