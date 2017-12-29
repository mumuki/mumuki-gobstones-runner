class GobstonesMetadataHook < Mumukit::Hook
  def metadata
    {
      language: {
        name: 'gobstones',
        icon: {type: 'devicon', name: 'gobstones'},
        version: 'v1.0.0',
        extension: 'gbs',
        ace_mode: 'gobstones',
        graphic: true
      },
      assets_urls: {
        js: [
          'assets/webcomponents.js'
        ],
        html: [
          'assets/polymer.html',
          'assets/gs-board.html'
        ]
      },
      test_framework: {
        name: 'metatest',
        test_extension: 'yml'
      }
    }
  end
end
