Basic use:

``` ruby
search = Search.new(:kjv)
result = search.query("raising hands")

puts result.show_by_page(1)
```

# Searching

## Search.new
## Search.query
## Search.result

# Results

## Result.matches
## Result.list
## Result.show
## Result.show_by_page
## Result.limit

# Create indexes

## IndexBuilder
