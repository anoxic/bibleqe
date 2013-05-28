TODO

Towards a web release:
[ ] Web gateway
[-] Paginate results vs. printing all

Later:
[ ] Feature: List result references vs. whole verse
[ ] Use only UTF-8 for all files
[ ] Searching is too slow: Binary search

Finished:
[x] Use a multi-line input, with one verse per line.
[x] Create an index (as an array first) capturing word frequencies
[x] In the index, catch the line number + word number (in verse)
[x] Ignore comment lines when creating index
[x] Use a "label" in the source on each line that tells the book, 
    verse, chapter (ignore label in index)
[x] Basic search functions
[x] Allow sidenotes (marked with >) and headings (marked with #) in the text
[x] Handle the "Found x matches for ..." line
[x] Handle results with no matches
[x] Multi-word search
[x] Allow commandline parameters for search
[x] Full text name set in the text
[x] Add full KJV text
[x] Allow ignored characters (i.e. .,:;()[]{}?!) to be set in the text
[x] Make full specification
[x] Printing is too slow: Instead of loading entire file, 
    load from stream, skipping lines
[x] Searching is too slow: Start within the context of the first letter