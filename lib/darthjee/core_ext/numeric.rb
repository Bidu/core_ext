class Numeric
  def percent_of(total)
    return Float::INFINITY if total == 0
    (to_f / total.to_f) * 100.0
  end
end
