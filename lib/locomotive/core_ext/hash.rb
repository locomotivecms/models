class Hash

  def method_missing method_name, *args
    return self.fetch(method_name.to_s) if self.has_key?(method_name.to_s)
    super
  end

end
