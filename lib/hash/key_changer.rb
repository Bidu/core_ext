class Hash::KeyChanger
  attr_reader :hash, :block

  def initialize(hash)
    @hash = hash
  end

  def change_keys(settings = {}, &block)
    merge_options({
      recursive: true
    }, settings)

    if options[:recursive]
      hash.deep_transform_keys!(&block)
    else
      hash.transform_keys!(&block)
    end
  end

  def camelize_keys(settings = {})
    merge_options({
      uppercase_first_letter: true
    }, settings)

    type = options[:uppercase_first_letter] ? :upper : :lower

    change_keys do |k|
      k.camelize(type)
    end
  end

  def change_text(options = {}, &block)
    merge_options({
      type: :keep
    }, options)

    change_keys do |key|
      cast_new_key block.call(key), key.class
    end
  end

  private

  def merge_options(default, custom)
    @options = {}.merge!(default).merge!(custom).merge!(options)
  end

  def options
    @options ||= {}
  end

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