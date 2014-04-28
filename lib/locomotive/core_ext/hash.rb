class Hash

  def has_key_indifferent_access? key
    self.has_key?(key.to_s) or self.has_key?(key.to_sym)
  end

  def respond_to? method_name
    return true if has_key_indifferent_access?(method_name)
    super
  end

  def method_missing method_name, *args
    return self.deep_stringify_keys.fetch(method_name.to_s) if has_key_indifferent_access?(method_name)
    super
  end

  # Returns a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
  def deep_transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
    end
    result
  end

  # Returns a new hash with all keys converted to strings.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #   hash = { person: { name: 'Rob', age: '28' } }
  #
  #   hash.deep_stringify_keys
  #   # => {"person"=>{"name"=>"Rob", "age"=>"28"}}
  def deep_stringify_keys
    deep_transform_keys{ |key| key.to_s }
  end
end
