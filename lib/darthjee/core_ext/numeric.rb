# frozen_string_literal: true

class Numeric
  def percent_of(total)
    return Float::INFINITY if total&.zero?
    (to_f / total.to_f) * 100.0
  end
end
