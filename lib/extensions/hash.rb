class Hash
  def only_keys(keys)
    except_keys(self.keys - keys)
  end

  def except_keys(keys)
    dup.except_keys!(keys)
  end

  def except_keys!(keys)
    keys.each { |key| delete(key) }
    self
  end
end
