## Object

### .default_value
Adds a method with default value

```ruby
class TheClass
  default_value :the_method, 10
end.new.the_method
```

will return

```ruby
10
```

### .default_values
Add several methods with single return value

```ruby
class TheIntermediateChild < TheParent
  default_values :is_child?, :is_final?, true
end.new.is_child?
```

will return

```ruby
true
```

### #is_any?
returns if the object is an instance of any of the given classes

```ruby
1.is_any?(String, Symbol)
```
returns
```ruby
false
```

```ruby
1.is_any?(String, Symbol, Numeric)
```
returns
```ruby
false
```
