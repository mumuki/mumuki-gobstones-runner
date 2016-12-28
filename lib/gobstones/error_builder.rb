module Gobstones
  def self.build_error(error)
    position = error[:on][:range][:start]
    "[#{position[:row]}:#{position[:column]}]: #{error[:message]}"
  end
end
