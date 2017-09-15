class Hash::ValueChanger::Dummy
  attr_reader :value

  delegate :+, to: :value

  def initialize(value)
    @value = value
  end

  def as_json
    { val: value }
  end

  def eql?(other)
    return true if equals?(other)
    return false unless other.is_a?(self.class)
    a.value == value
  end
end
