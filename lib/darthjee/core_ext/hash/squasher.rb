# frozen_string_literal: true

class Hash
  module Squasher
    def self.squash(origin)
      {}.tap do |hash|
        origin.each do |key, value|
          if value.is_a? Hash
            value.squash.each do |k, v|
              new_key = [key, k].join('.')
              hash[new_key] = v
            end
          else
            hash[key] = value
          end
        end
      end
    end
  end
end
