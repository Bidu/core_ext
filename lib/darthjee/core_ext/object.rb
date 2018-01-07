class Object
  def is_any?(*classes)
    classes.any? do |clazz|
      is_a?(clazz)
    end
  end
end
