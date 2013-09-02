Basic use:

``` ruby
search = Search.new(:kjv)
result = search.query("raising hands")

puts result.show_by_page(1)
```

Regex word search:

``` ruby
```

# Searching

## Search.new

    Search.new()
    Search.new(<version>)

## Search.query

    search = Search.new()
    search.query("word otherword")
    search.query("this|orthat")
    search.query("/rais.*/")

Takes a string of space separated argument or an array.
You can include any word, OR group, and regex in a query, so "word this|orthat otherword /rais.*/" is valid.

## Search.result

Returns a Result object

# Results

## Result.matches
## Result.list
## Result.show
## Result.show_by_page
## Result.limit

# Create indexes

## IndexBuilder
