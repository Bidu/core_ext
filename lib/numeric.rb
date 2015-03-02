class Numeric
  def percent_of(n)
    return Float::INFINITY if n == 0
    (to_f / n.to_f) * 100.0
  end
end
