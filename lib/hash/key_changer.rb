class Hash::KeyChanger
  attr_reader :options, :hash, :block

  def initialize(hash)
    @hash = hash
  end

  def change_text(options = {}, &block)
    @options = {
      type: :keep
    }.merge(options)
    @block = block

    hash.change_keys(options) do |key|
      cast_new_key block.call(key), key.class
    end
  end

  private

  def cast_new_key(key, old_clazz)
    case class_cast(old_clazz)
    when :symbol then
      key.to_sym
    when :string then
      key.to_s
    end
  end

  def keep_class?
    options[:type] == :keep
  end

  def class_cast(old_clazz)
    keep_class? && old_clazz.to_s.downcase.to_sym || options[:type]
  end
end