class Date
  def days_between(other_date)
    (other_date - self).abs
  end
end
