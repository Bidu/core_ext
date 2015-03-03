class Hash::KeyTextChanger
  attr_reader :options, :hash, :block

  def initialize(hash, options = {}, &block)
    @hash = hash
    @options = {
      type: :keep
    }.merge(options)
    @block = block
  end

  def change
    hash.change_keys(options) do |key|
      cast_new_key block.call(key), key.class, options
    end
  end

  private

  def cast_new_key(key, old_clazz, options = {})
    key = key.to_sym if options[:type] == :symbol || (old_clazz == Symbol && options[:type] == :keep)
    key = key.to_s if options[:type] == :string || (old_clazz == String && options[:type] == :keep)
    key
  end
end