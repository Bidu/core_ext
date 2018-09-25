# frozen_string_literal: true

module Darthjee
  module CoreExt
    module Class
      private

      # @!visibility public
      # Adds a method that will return a default value
      #
      # the value is evaluated on class definition, meaning that
      # everytime it is called it will be the same instance
      #
      # @param [Symbol/String] name Name of the method to be added
      # @param [Object] value default value
      #
      # @example Defining a default value
      #   class MyClass
      #     default_value :name, 'John'
      #   end
      #
      #   MyClass.new.name # returns 'John'
      #
      # @example Comparing value across instances
      #   # frozen_string_literal: false
      #
      #   class MyClass
      #     default_value :name, 'John'
      #   end
      #
      #   instance = MyClass.new
      #   other = MyClass.new
      #
      #   instance.name.equal?('John')      # returns false
      #   instance.name.equal?(other.name)  # returns true
      def default_value(name, value)
        define_method(name) { |*_| value }
      end

      # @!visibility public
      # Adds methods that will return a default value
      #
      # the value is evaluated on class definition, meaning that
      # everytime any of them are called they will return the same instance
      # of value
      #
      # @param [Array of Symbol/String] names Names of the methods to be added
      # @param [Object] value default value
      #
      # @example Defining a default values
      #   class MyClass
      #     default_values :name, :nick_name, 'John'
      #   end
      #
      #   MyClass.new.name      # returns 'John'
      #   MyClass.new.nick_name # returns 'John'
      #
      # @example Comparing value across instances
      #   # frozen_string_literal: false
      #
      #   class MyClass
      #     default_values :name, :nick_name, 'John'
      #   end
      #
      #   instance = MyClass.new
      #   other = MyClass.new
      #
      #   instance.name.equal?('John')     # returns false
      #   instance.name.equal?(other.name) # returns true
      #
      # @example Comparing value across methods
      #   # frozen_string_literal: false
      #
      #   class MyClass
      #     default_values :name, :nick_name, 'John'
      #   end
      #
      #   instance = MyClass.new
      #
      #   instance.nick_name.equal?('John')        # returns false
      #   instance.nick_name.equal?(instance.name) # returns true
      def default_values(*names, value)
        names.each do |name|
          default_value(name, value)
        end
      end
    end
  end
end

class Class
  include Darthjee::CoreExt::Class
end
