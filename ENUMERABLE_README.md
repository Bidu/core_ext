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

