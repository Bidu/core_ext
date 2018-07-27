# frozen_string_literal: true

class Symbol
  def camelize(type = :upper)
    to_s.camelize(type).to_sym
  end

  def underscore
    to_s.underscore.to_sym
  end
end
