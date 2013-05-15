TODO

Finished:
[x] Use a multi-line input, with one verse per line.
[x] Create an index (as an array first) capturing word frequencies
[x] In the index, catch the line number + word number (in verse)
[x] Ignore comment lines when creating index
[x] Use a "label" in the source on each line that tells the book, verse, chapter (ignore label)
[x] Basic search functions
[x] Allow sidenotes (marked with >) and headings (marked with #) in the text
[x] Handle the "Found x matches for ..." line
[x] Handle results with no matches
[x] Multi-word search
[x] Allow commandline parameters for search
[x] Full text name set in the text

Towards a web release:
[ ] Add full KJV text
[ ] Web gateway

Later:
[ ] List references
[ ] Allow ignored characters (i.e. .,:;()[]{}?!) to be set in the text (via `strip` flag)
[ ] Allow the File and Index classes to take a text from somewhere other that a file already on the system and create the system files