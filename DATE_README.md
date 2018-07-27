## Date

### #days_between

Returns the number of days between 2 dates

```ruby
d1 = Date.new(2106, 10, 11)
d2 = d1 + 1.year
d3 = d1 - 1,year
```

```ruby
d1.days_between(d2) == 365
```

```ruby
d1.days_between(d3) = 366
```
