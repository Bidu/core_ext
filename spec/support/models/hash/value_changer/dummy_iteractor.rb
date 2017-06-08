class Hash::ValueChanger::DummyIteractor
  def initialize(*array)
    @array = array
  end

  delegate :each, :to_a, to: :array

  private

  attr_reader :array
end

