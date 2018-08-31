# frozen_string_literal: true

class Hash
  module Transposeable
    def transpose!
      aux = dup
      keys.each { |k| delete(k) }
      aux.each do |k, v|
        self[v] = k
      end
      self
    end

    def transpose
      {}.tap do |new_hash|
        each do |k, v|
          new_hash[v] = k
        end
      end
    end
  end
end
