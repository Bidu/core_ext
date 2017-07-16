class Date
  def days_between(other_date)
    (self - other_date.to_date).abs
  end
end
