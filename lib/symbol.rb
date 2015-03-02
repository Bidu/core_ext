class Symbol
  def camelize(type = :upper)
    to_s.camelize(type).to_sym
  end
end
