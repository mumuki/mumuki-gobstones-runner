module Gobstones::BatchParser
  class << self
    def parse(request)
      test = parse_test(request)

      options = parse_options(test).merge(parse_settings(request))
      examples = parse_examples test, options

      Gobstones::Batch.new request.content, examples, request.extra, options
    end

    private

    def parse_settings(request)
      { game_framework: request.settings.try { |s| s['game_framework'] } || false }
    end

    def parse_test(request)
      YAML.load(request.test).deep_symbolize_keys
    end

    def parse_examples(test, options)
      examples = test[:examples]
      examples.each_with_index.map do |example, index|
        parse_example options, {
          id: index,
          name: example[:title],
          preconditions: example.slice(*preconditions),
          postconditions: example.slice(*postconditions)
        }
      end
    end

    def parse_example(options, example)
      return example unless options[:subject]

      return_value = example[:postconditions][:return]
      if return_value
        example[:name] = "#{options[:subject]}() -> #{return_value}" unless example[:name]
        options[:show_final_board] = false
      end

      example
    end

    def parse_options(test)
      [
        struct(key: :show_initial_board, default: true),
        struct(key: :show_final_board, default: true),
        struct(key: :check_head_position, default: false),
        struct(key: :expect_endless_while, default: false),
        struct(key: :interactive, default: false),
        struct(key: :subject, default: nil)
      ].map { |it| [
          it.key,
          if test[it.key].nil?
            it.default
          else
            test[it.key]
          end
        ]
      }.to_h
    end

    def preconditions
      [:initial_board, :arguments]
    end

    def postconditions
      [:final_board, :error, :return]
    end
  end
end
