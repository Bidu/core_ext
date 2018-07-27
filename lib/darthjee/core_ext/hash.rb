# frozen_string_literal: true

class Hash
  autoload :ValueChanger,        'darthjee/core_ext/hash/value_changer'
  autoload :DeepHashConstructor, 'darthjee/core_ext/hash/deep_hash_constructor'
  autoload :KeyChanger,          'darthjee/core_ext/hash/key_changer'
  autoload :ChainFetcher,        'darthjee/core_ext/hash/chain_fetcher'
  autoload :Squasher,            'darthjee/core_ext/hash/squasher'

  def chain_fetch(*keys, &block)
    ChainFetcher.new(self, *keys).fetch(&block)
  end

  def squash
    Squasher.squash(self)
  end

  def map_to_hash
    {}.tap do |hash|
      each do |k, v|
        hash[k] = yield(k, v)
      end
    end
  end

  def remap_keys(remap)
    dup.remap_keys!(remap)
  end

  def remap_keys!(remap)
    new_hash = {}
    remap.each do |o, n|
      new_hash[n] = delete o
    end
    merge! new_hash
  end

  def lower_camelize_keys(options = {})
    dup.lower_camelize_keys!(options)
  end

  def lower_camelize_keys!(options = {})
    options = options.merge(uppercase_first_letter: false)

    camelize_keys!(options)
  end

  def camelize_keys(options = {})
    dup.camelize_keys!(options)
  end

  def camelize_keys!(options = {})
    Hash::KeyChanger.new(self).camelize_keys(options)
  end

  def underscore_keys(options = {})
    dup.underscore_keys!(options)
  end

  def underscore_keys!(options = {})
    Hash::KeyChanger.new(self).underscore_keys(options)
  end

  def exclusive_merge(hash)
    dup.exclusive_merge!(hash)
  end

  def exclusive_merge!(hash)
    merge!(hash.slice(*keys))
  end

  # change all keys returning the new map
  # options: { recursive: true }
  # ex: { "a" =>1 }.change_keys{ |key| key.upcase } == { "A" => 1 }
  def change_keys(options = {}, &block)
    deep_dup.change_keys!(options, &block)
  end

  # change all keys returning the new map
  # options: { recursive: true }
  # ex: { "a":1 }.change_keys{ |key| key.upcase } == { "A":1 }
  def change_keys!(options = {}, &block)
    Hash::KeyChanger.new(self).change_keys(options, &block)
  end

  # change all publicaly sending method calls
  # options: { recursive: true }
  # ex: { a: 1 }.chain_change_keys(:to_s, :upcase) == { "A" =>1 }
  def chain_change_keys(*calls)
    deep_dup.chain_change_keys!(*calls)
  end

  # change all publicaly sending method calls
  # options: { recursive: true }
  # ex: { a: 1 }.chain_change_keys(:to_s, :upcase) == { "A" =>1 }
  def chain_change_keys!(*calls)
    options = calls.extract_options!

    calls.inject(self) do |h, m|
      h.change_keys!(options, &m)
    end
  end

  # prepend a string to all keys
  # options {
  #  recursive: true,
  #  type: :keep [keep, string, symbol] (key type to be returned)
  # }
  # ex: { :a => 1, "b"=> 2 }.prepend_to_keys("foo_") == { :foo_a => 1, "foo_b"=> 2 }
  def prepend_to_keys(str, options = {})
    change_key_text(options) do |key|
      "#{str}#{key}"
    end
  end

  # append a string to all keys
  # options {
  #  recursive: true,
  #  type: :keep [keep, string, symbol] (key type to be returned)
  # }
  # ex: { :a => 1, "b"=> 2 }.append_to_keys("_bar") == { :a_bar => 1, "b_bar"=> 2 }
  def append_to_keys(str, options = {})
    change_key_text(options) do |key|
      "#{key}#{str}"
    end
  end

  # sorts keys for hash
  # options: { recursive: true }
  # ex: { b:1, a:2 }.sort_keys == { a:2, b:1 }
  def sort_keys(options = {})
    options = {
      recursive: true
    }.merge(options)

    {}.tap do |hash|
      keys.sort.each do |key|
        value = self[key]
        hash[key] = value unless value.is_a?(Hash) && options[:recursive]
        hash[key] = value.sort_keys(options) if value.is_a?(Hash) && options[:recursive]
      end
    end
  end

  # creates a new hash with changes in its values
  # options: {
  #   recursive: true,
  #   skip_hash:true
  # }
  # ex: { a:1, b:2 }.change_values{ |v| v+1 } == { a:2, b:3 }
  # ex: { a:1, b:{ c:1 } }.change_values(skip_hash:false) { |v| v.to_s } == { a:"1", b:"{ c=>1 }
  # ex: { a:1, b:{ c:1 } }.change_values(skip_hash:true) { |v| v.to_s } == { a:"1", b:{ c=>"1" } }
  def change_values(options = {}, &block)
    deep_dup.change_values!(options, &block)
  end

  def change_values!(options = {}, &block)
    Hash::ValueChanger.new(options, &block).change(self)
  end

  def to_deep_hash(separator = '.')
    Hash::DeepHashConstructor.new(separator).deep_hash(self)
  end

  def transpose!
    aux = dup
    keys.each { |k| delete(k) }
    aux.each do |k, v|
      self[v] = k
    end
    self
  end

  def transpose
    {}.tap do |new_hash|
      each do |k, v|
        new_hash[v] = k
      end
    end
  end

  private

  # changes the text of the keys
  # options {
  #  recursive: true,
  #  type: :keep [keep, string, symbol] (key type to be returned)
  # }
  # ex: { :a => 1, "b"=> 2 }.change_key_text{ |key| key.upcase } == { :A => 1, "B"=> 2 }
  def change_key_text(options = {}, &block)
    Hash::KeyChanger.new(self).change_text(options, &block)
  end
end
