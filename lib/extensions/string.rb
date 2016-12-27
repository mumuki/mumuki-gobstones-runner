class String
  def parse_as_json()
    JSON.parse(self, symbolize_names: true)
  end

  def initial_is_lower?
    initial.lower?
  end

  def initial
    slice 0, 1
  end

  def lower?
    self == downcase
  end
end
