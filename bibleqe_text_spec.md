# BibleQE Text (File for indexing or searching) Specification Version 1 R1

    Brian Zick <brian@zickzickzick.com>
    April 2012 
    
---

## File format

The text should be in plain text format. Encoded in Unicode UTF-8 where possible.

## Overview

Each line is considered a single verse, except for lines starting in any of the following: !#>

A reference (or short reference) begins each line, separated by a delimeter. The delimeter can be set by the text file creator using the `delim` flag. Anything not occuring in the text can be used. It could be a unicode charactar like '♥' or any other charactar or grouping, like: =>, ::, =, ...

Paragraphs are also allowed

## Comments

Lines starting in '!' are comments. They can occur anywhere in the text.

## Flags

There are special comments that act as setting flags, these are:

1. `version` -- text file version, currently version 1
2. `delim` -- the delimiter between the reference and the verse, I prefer the double colon - '::'
3. `strip` -- characters to strip from the text before indexing, right now: .,:;()[]{}?! (Note that this is not available in the present implementation and will be ignored)

## Paragraphs

You can mark a paragraph in the text by using the '¶' mark at the beginning of the verse the paragraph begins on.

## Example

    ! BibleQE test text
	! version 1
	! delim ::
	! strip .,:;()[]{}?!
	# Example Heading
	Jhn 3:1 :: ¶ There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:
	Jhn 3:2 :: The same came to Jesus by night, and said unto him, Rabbi, we know that thou art a teacher come from God: for no man can do these miracles that thou doest, except God be with him.
	> Example sidenote.
	Jhn 3:3 :: Jesus answered and said unto him, Verily, verily, I say unto thee, Except a man be born again, he cannot see the kingdom of God.
	> Note 2.
	Jhn 3:4 :: Nicodemus saith unto him, How can a man be born when he is old? can he enter the second time into his mother's womb, and be born?
	Jhn 3:5 :: Jesus answered, Verily, verily, I say unto thee, Except a man be born of water and [of] the Spirit, he cannot enter into the kingdom of God.
	Jhn 3:6 :: That which is born of the flesh is flesh; and that which is born of the Spirit is spirit.
	Jhn 3:7 :: Marvel not that I said unto thee, Ye must be born again.
    