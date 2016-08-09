class HtmlRenderer
  def render(json_result)
    @result =  parse_json json_result
    template_file.result binding
  end

  private

  def template_file
    ERB.new File.read("#{__dir__}/records.html.erb")
  end

  def parse_json(json_result)
    JSON.parse(json_result).deep_symbolize_keys
  end
end