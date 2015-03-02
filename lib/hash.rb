require 'hash/value_changer'
require 'hash/deep_hash_constructor'

class Hash
  def squash
    {}.tap do |hash|
      each do |key, value|
        if value.is_a? Hash
          value.squash.each do |k, v|
            new_key = [key, k].join('.')
            hash[new_key] = v
          end
        else
          hash[key] = value
        end
      end
    end
  end

  def lower_camelize_keys(options = {})
    dup.lower_camelize_keys!(options)
  end

  def lower_camelize_keys!(options = {})
    options = options.merge({ uppercase_first_letter: false })

    camelize_keys!(options)
  end

  def camelize_keys(options = {})
    dup.camelize_keys!(options)
  end

  def camelize_keys!(options = {})
    options = {
      uppercase_first_letter: true
    }.merge(options)

    type = options[:uppercase_first_letter] ? :upper : :lower

    change_keys!(options) do |k|
      k.camelize(type)
    end
  end

  # change keys to stringrecursively
  # { :a=>1, :b => { c:2 } }.deep_stringfy_keys == { "a"=>1, "b" => { "c" => 2 } }
  def deep_stringfy_keys
    change_keys({ recursive: true }) { |key| key.to_s }
  end

  # change keys to symbols
  # { "a"=>1, "b" => { "c" => 2 } }.deep_symbolize_keys == { :a=>1, :b => { c:2 } }
  def deep_symbolize_keys
    change_keys({ recursive: true }) { |key| key.to_sym }
  end

  # change all keys returning the new map
  # options: { recursive: true }
  # ex: { "a":1 }.change_keys{ |key| key.upcase } == { "A":1 }
  def change_keys(options = {}, &block)
    deep_dup.change_keys!(options, &block)
  end

  # change all keys returning the new map
  # options: { recursive: true }
  # ex: { "a":1 }.change_keys{ |key| key.upcase } == { "A":1 }
  def change_keys!(options = {}, &block)
    options = {
      recursive: true
    }.merge(options)

    if options[:recursive]
      deep_transform_keys!(&block)
    else
      transform_keys!(&block)
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

  private

  # changes the text of the keys
  # options {
  #  recursive: true,
  #  type: :keep [keep, string, symbol] (key type to be returned)
  # }
  # ex: { :a => 1, "b"=> 2 }.change_key_text{ |key| key.upcase } == { :A => 1, "B"=> 2 }
  def change_key_text(options = {})
    options = {
      type: :keep
    }.merge(options)

    change_keys(options) do |key|
      str = yield(key)
      str = str.to_sym if options[:type] == :symbol || (key.is_a?(Symbol) && options[:type] == :keep)
      str = str.to_s if options[:type] == :string || (key.is_a?(String) && options[:type] == :keep)
      str
    end
  end
end