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
      layout_assets_urls: {
        html: [
          'assets/polymer.html',
          'assets/gs-board.html'
        ]
      },
      editor_assets_urls: {
        js: [
          'assets/editor/editor.js'
        ],
        html: [
          'assets/editor/editor.html',
        ],
        css: [
          'assets/editor/editor.css'
        ]
      },
      test_framework: {
        name: 'metatest',
        test_extension: 'yml'
      }
    }
  end
end
