Core_Ext
========

# Usage
This project adds some new methods to the core ruby classes

To use core-ext either intall directly

```console
gem install darthjee-core_ext
```

or add it to Gemfile

```
gem 'darthjee-core_ext'
```

```console
bundle install darthjee-core_ext
```

#methods added

## Array
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

## Hash
### #map_to_hash
map returning a hash with the original keys

```ruby
hash = { a: 1, b: 2 }
hash.map_to_hash { |k, v| "#{k}_#{v}" }
{ a: "a_1", b: "b_2" }
```

### #chain_fetch
Applies fetch in a chain

```ruby
{ a: { b: { c: { d: 10 } } } }.chain_fetch(:a, :b, :c, :d)
10
```

A block can be passed so that when a key is not found, the block will define the value to be returned

```ruby
h = { a: { b: { c: { d: 10 } } } }
h.chain_fetch(:a, :x, :y, :z) { |key, missed_keys| "returned #{key}" }
'returned x'
```

### #squash
Squash a deep hash into a simple level hash

```ruby
  { a: { b:1 } }.squash
```
returns
```ruby
  { 'a.b' => 1 }
```

### #to_deep_hash
Changes a hash spliting keys into inner hashs

```ruby
  { 'a.b' => 1 }.to_deep_hash
```
returns
```ruby
  { 'a' => { 'b' => 1 } }
```

### #camelize_keys
Change the keys camelizing them and accepting parameters:
- uppercase_first_letter: Use the java or javascript format (default: true)
- recursive: when true, does it recursivly through inner arrays (default: true)

```ruby
  { ca_b: 1, k: [{ a_b: 1 }] }.camelize_keys
```
returns
```ruby
  {:CaB=>1, :K=>[{:AB=>1}]}
```

```ruby
  { ca_b: 1, k: [{ a_b: 1 }] }.camelize_keys(recursive: false)
```
returns
```ruby
  {:CaB=>1, :K=>[{:a_b=>1}]}
```

```ruby
  { ca_b: 1, k: [{ a_b: 1 }] }.camelize_keys(uppercase_first_letter: false)
```
returns
```ruby
  {:caB=>1, :k=>[{:aB=>1}]}
```

### #change_keys
Change the array keys using a block accepting parameters:
 - recursive: when true, does it recursivly through inner arrays (default: true)

```ruby
  { ca_b: 1, k: [{ a_b: 1 }] }.change_keys { |k| k.to_s.upcase }
```
returns
```ruby
  {"CA_B"=>1, "K"=>[{"A_B"=>1}]}
```

```ruby
  { ca_b: 1, k: [{ a_b: 1 }] }.change_keys(recursive: false) { |k| k.to_s.upcase }
```
returns
```ruby
  {"CA_B"=>1, "K"=>[{:a_b=>1}]}
```

### #chain_change_keys
Change the hash keys usin a chained method call

```ruby
  { ca_b: 1 }.chain_change_keys(:to_s, :upcase, :to_sym)
```
returns
```ruby
  { CA_B: 1 }
```

### #change_values
Change the values of the array accepting parametes:
 - recursive: when true, does it recursivly through inner arrays and hashes (default: true)
 - skip_inner: when true, do not call the block for iterators such as Hash and Arrays (default: true)

```ruby
  { a: 1, b: [{ c: 2 }] }.change_values { |v| (v+1).to_s }
```
returns
```ruby
  { a: '2' b: [{ c: '3' }] }
```

```ruby
  { a: 1, b: [{ c: 2 }] }.change_values(recursive: false) { |v| (v+1).to_s }
```
returns
```ruby
  { a: '2' b: [{ c: 2 }] }
```

```ruby
  { a: 1, b: [{ c: 2 }] }.change_values(skip_inner: false) { |v| v.is_a?(Integer) ? (v+1).to_s : v.class }
```
returns
```ruby
  { a: '2' b: Array }
```

### #prepend_to_keys
Change each keys prepending an string

```ruby
  { key: 1 }.prepend_to_keys 'scope:'
```
returns
```ruby
  { :'scope:key' => 1 }
```
### #append_to_keys
Change each keys appending an string

```ruby
  { key: 1 }.append_to_keys 's'
```
returns
```ruby
  { keys: 1 }
```

### #sort_keys
Sort the hash usig the keys

```ruby
  { b:1, a:2 }.sort_keys
```
returns
```ruby
  { a:2, b:1 }
```

### #map_to_hash
map returning a hash with the original keys for keys

```ruby
hash = { a: 1, b: 2 }
hash.map_to_hash { |k, v| "#{k}_#{v}" }
{ a: 'a_1', b: 'b_2' }
```

## Enumerable

### #clean!
Cleans empty values from a hash
```ruby
{ a: 1, b: [], c: nil, d: {}, e: '', f: { b: [], c: nil, d: {}, e: '' } }.clean!
```
returns
```ruby
  {}
```

