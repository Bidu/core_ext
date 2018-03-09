module Math
  def self.average(values)
    if values.is_a? Array
      values.sum / values.size.to_f
    else
      values.inject(0) do |sum, vals|
        sum + vals.inject { |a,b| a * b }
      end / values.values.sum.to_f
    end
  end
end
