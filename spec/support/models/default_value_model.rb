# frozen_string_literal: true

class DefaultValueModel
  default_value :x, 10
  default_values :y, :z, 20
  default_value :array, [10, 20]
  default_values :hash, :json, { a: 1 }
end
