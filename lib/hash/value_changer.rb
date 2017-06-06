class Hash::ValueChanger
  attr_accessor :options, :block

  class << self
    def iterator_classes
      @iterator_classes ||= [Array, Hash]
    end
  end

  def initialize(options, &block)
    @options = {
      recursive: true,
      skip_inner: true
    }.merge(options)

    @block = block
  end

  def change(object)
    if object.is_a? Hash
      change_hash(object)
    elsif object.is_a? Array
      change_array(object)
    end
  end

  private

  def change_hash(original_hash)
    original_hash.tap do |hash|
      original_hash.each do |key, value|
        value = new_value(value)
        hash[key] = value
      end
    end
  end

  def change_array(array)
    array.each.with_index do |value, index|
      value = value.change_values(options, &block) if value.is_a? Hash
      value = change_array(value) if value.is_a? Array
      array[index] = value
    end
  end

  def change_value?(value)
    !iterable_value?(value) || !options[:skip_inner]
  end

  def iterable_value?(value)
    value.is_a?(Hash) || value.is_a?(Array)
  end

  def new_value(value)
    value = block.call(value) if change_value?(value)
    apply_recursion?(value) ? change(value) : value
  end

  def apply_recursion?(value)
    is_iterator(value) && options[:recursive]
  end

  def is_iterator(value)
    self.class.iterator_classes.any? { |klazz| value.is_a?(klazz) }
  end
end
