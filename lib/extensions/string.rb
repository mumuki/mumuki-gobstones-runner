class String
  def parse_as_json()
    JSON.parse(self, symbolize_names: true)
  end

  def initial_is_lower
    self.initial.is_lower?
  end

  def initial
    self[0, 1]
  end

  def is_lower?
    self == self.downcase
  end
end
