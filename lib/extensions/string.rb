class String
  def parse_as_json()
    JSON.parse(self, symbolize_names: true)
  end
end
