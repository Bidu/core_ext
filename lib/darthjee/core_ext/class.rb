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
      # @param [::Symbol,::String] name Name of the method to be added
      # @param [::Object] value default value
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
      # @param [::Array<::Symbol,::String>] names Names of the
      #   methods to be added
      # @param [::Object] value default value
      #
      # @see default_value
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

      # @!visibility public
      #
      # Creates a method that will act as reader, but will
      # return a default value when the instance variable
      # was never set
      #
      # @example Defining a default value
      #   class Person
      #     attr_writer :name
      #     default_reader :name, 'John Doe'
      #   end
      #
      #   model = Person.new
      #
      #   model.name # returns 'John Doe'
      #
      # @example Changing the instance value
      #
      #   model = Person.new
      #   model.name # returns 'John Doe'
      #
      #   model.name = 'Joe'
      #   model.name # returns 'Joe'
      #
      #   model.name = nil
      #   model.name # returns nil
      #
      # @example Changing values accros instances
      #
      #   model = Person.new
      #   model.name # returns 'John Doe'
      #
      #   model.name = 'Bob'
      #   model.name # returns 'Bob'
      #   Person.new.name # returns 'John Doe'
      def default_reader(name, value)
        define_method(name) do
          return value unless instance_variable_defined?("@#{name}")
          instance_variable_get("@#{name}")
        end
      end

      # @!visibility public
      #
      # Creates methods that will act as readers, but will
      # return a default value when the instance variables
      # ware never set
      #
      # @example Defining default values
      #   class Person
      #     attr_writer :cars, :houses
      #     default_reader :cars, :houses, 'none'
      #   end
      #
      #   model = Person.new
      #
      #   model.cars # returns 'none'
      #
      # @example Changing the instance value
      #
      #   model = Person.new
      #   model.cars # returns 'none'
      #
      #   model.cars = ['volvo']
      #   model.cars # returns ['volvo']
      #
      #   model.cars = nil
      #   model.cars # returns nil
      #
      # @example Changing values accros instances
      #
      #   model = Person.new
      #   model.cars # returns 'none'
      #
      #   model.cars = ['volvo']
      #   model.cars # returns ['volvo']
      #   Person.new.cars # returns 'none'
      #
      # @example Comparing value across methods
      #   model.cars                           # returns 'none'
      #   model.cars.equal?('none')            # returns false
      #   model.nick_name.equal?(model.houses) # returns true
      def default_readers(*names, value)
        names.each do |name|
          default_reader(name, value)
        end
      end
    end
  end
end

class Class
  include Darthjee::CoreExt::Class
end
