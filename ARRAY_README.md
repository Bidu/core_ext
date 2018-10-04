## Array
### #average
returns the average of the values in the array

```ruby
array = [1, 2, 3, 4]
array.average # returns 2.5
```

### #map_to_hash
map returning a hash with the original array for keys

```ruby
array = %w(a ab)
arrays.map_to_hash { |val| val.length }
{ 'a' => 1, 'b' => 2 }
```

### #chain_map
applies map in a chain

```ruby
array = [ :a, :long_name, :sym ]
array.chain_map(:to_s, :size, :to_s)
[ '1', '9', '3' ]
```

```ruby
array = [ :a, :long_name, :sym ]
array.chain_map(:to_s, :size) { |v| "final: #{v}" }
[ 'final: 1', 'final: 9', 'final: 3' ]
```

### #as_hash
Creates a hash from the array using the argumen array as keys

```ruby
  [1, 2, 3].as_hash %w(a b c)
```
returns
```ruby
  { 'a' => 1, 'b' => 2, 'c' => 3 } }
```
