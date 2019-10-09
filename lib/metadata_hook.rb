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
          'assets/gs-board.html',
          'assets/layout/layout.html'
        ]
      },
      editor_assets_urls: {
        js: [
          'assets/editor/editor.js'
        ],
        html: [
          'assets/editor/editor.html'
        ],
        css: [
          'assets/editor/editor.css'
        ],
        shows_loading_content: true
      },
      test_framework: {
        name: 'metatest',
        test_extension: 'yml'
      }
    }
  end

  def template
    <<YAML
    ##  OPTIONS
    # show_initial_board: true
    # show_final_board: true
    # check_head_position: false
    # expect_endless_while: false
    # subject: functionOrProcedure 
    examples:
      - title: 'Example board title'
      # arguments:
        #- Sur
      initial_board: |
        GBB/1.0
        size 3 3
        cell 0 0 Rojo 1 Verde 1 Negro 1 Azul 1
        head 0 0
      final_board: |
        GBB/1.0
        size 3 3
        cell 0 0 Rojo 1 Verde 1 Negro 1 Azul 1
        head 0 0
    ## EXPECTED ERRORS
    # error: no_stones
    # error: out_of_board
    # error: wrong_argument_type
    # error: unassigned_variable
YAML
  end
end
