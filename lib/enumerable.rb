module Enumerable
  # delete hash or array values if value is nil
  # ex: { a: nil, b: 2 }.clean! => { b: 2 }
  def clean!
    if is_a?(Hash)
      delete_if { |_k, v| empty_value?(v) }
    else
      delete_if { |v| empty_value?(v) }
    end
  end

  private

  def empty_value?(v)
    v.nil? || v.try(:empty?) ||
      ((v.is_a?(Hash) || v.is_a?(Array)) && v.clean!.empty?)
  end
end