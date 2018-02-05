class Object
  class << self
    private

    def default_value(name, value)
      define_method(name) { |*_| value }
    end

    def default_values(*names, value)
      names.each do |name|
        default_value(name, value)
      end
    end
  end

  def is_any?(*classes)
    classes.any? do |clazz|
      is_a?(clazz)
    end
  end
end
