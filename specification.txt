# BibleQE Specification Version 2

May 2012 - Brian Zick  
This is marked throughout with `[x]` or `[ ]` to signal if the current code is conforming.

## Files `[x]`

Plaintext, UTF-8

Comment lines begin with `!`

All the files for texts should be kept in a single folder.

Right now, these are the files for a single Bible version:  
  
  `<name>.txt` The Bible text  
  `<name>.ind` The index  
  `<name>_toc.ind` Groups of words for index


### The Index

The index is made up of two files: <name>.ind, and  <name>_toc.ind

`<name>.ind` is the index file - e.g.

	! BibleQE Index: King James Version  
	! version 2  
	a 6,4 6,11 7,18 9,14 11,7 12,10 17,9 32,4 34,5  
	abideth 43,26
    
  
`<name>_toc.ind` keeps the "table of contents" for the index - e.g.

	! BibleQE Index TOC: King James Version
	! version 2
	a 2..19
	b 20..41
  
### The Bible text

Uses the flags version, deli, strip, and name

Lines containing verses begin with a URL (e.g. Jn 1:1) + a delimiter

Notes begin with `>`

Headings begin with `#`

Paragraphs can be marked (after the URL and delimiter) with a `¶`

	! BibleQE King James Version
	! version 1
	! delim ::
	! strip .,:;()[]{}?!
	# Example Heading
	> Example sidenote.
	Jhn 3:1 :: ¶ There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:


## Program

### Index Builder `[x]`

Line by line: 

1. Every verse which begins with a URL has the URL stripped
2. The line has all non-indexing characters stripped
3. Characters are down cased
4. The line is split into words
5. For every word, a new entry in the index is made,
   containing the line number and word number
6. It is written to a `<name>.ind` file.

### Index TOC `[x]`

For each word in the index, it get the word's first letter, adding it's range to a hash -  e.g. `{:a=>[2,18]}` And writes this to a `<name>_toc.ind` file.

### Search `[-]`

Word search `[ ]`:

1. It checks the first charactar of the given word
2. If a range exists in `<name>_toc.ind` for that letter, that range is loaded from `<name>.ind`
3. The search is then performed binary style

Multi-word (`and`) search [x]:

1. A word search for every given word is performed, returned the line number of every matching line
2. Those matches are combined into one array
3. The output of the search is given by selecting from that array all lines which  that exist the number