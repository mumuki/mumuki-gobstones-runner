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
          [extra, render_framework_file('extra.gbs')]
        end

        def compile_content(content)
          if blockly_code?(content)
            xml = Nokogiri::XML(content)
            xml.root.add_child render_framework_file('program.xml')
            xml.to_xhtml.gsub(/\n\s*/, '')
          else
            <<~GBS
            #{content}

            #{render_framework_file 'program.gbs'}
            GBS
                .chop
          end
        end

        private

        def blockly_code?(content)
          Nokogiri::XML(content).errors.empty?
        end

        def render_framework_file(name)
          ERB.new(File.read("lib/game_framework/#{name}.erb")).result
        end
      end
    end
  end
end
