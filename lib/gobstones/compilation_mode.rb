module Gobstones
  module CompilationMode
    module Classic
      class << self
        def compile_extra(extra)
          extra
        end

        def compile_content(content)
          content
        end
      end
    end

    module GameFramework
      class << self
        def compile_extra(extra)
          [extra, extra_code]
        end

        def compile_content(content)
          if blockly_code?(content)
            xml = Nokogiri::XML(content)
            xml.root.add_child render_framework_file('program.xml')
            xml.to_xhtml.gsub(/\n\s*/, '')
          else
            <<~GBS
            #{content}

            #{program_code}
            GBS
                .chop
          end
        end

        def extra_code
          render_framework_file 'extra.gbs'
        end

        def program_code
          render_framework_file 'program.gbs'
        end

        def default_code
          render_framework_file 'default.xml'
        end

        private

        def blockly_code?(content)
          content.start_with? '<xml'
        end

        def render_framework_file(name)
          ERB.new(File.read("lib/game_framework/#{name}.erb")).result
        end
      end
    end
  end
end
