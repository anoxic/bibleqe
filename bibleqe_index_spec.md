# BibleQE Index File Specification Version 1 R2

    Brian Zick <brian@zickzickzick.com>
    April 2012 
    
---

## File format

The index should be in plain text format. Encoded in Unicode UTF-8 where possible.

## Overview

Each line is considered a single word's index. It then has space separated values, starting with the WORD, then its FREQUENCY, and then each OCCURANCE in the source file. There is a special case for lines at the top of the file, beginning with a `!`, which are comment or flag lines. The only required flag is `version`.

## Numbering

All counting starts at `1`.

## Comments / Flags

All lines starting with `!` are ignored, and can be used for any type of comments needed. This should be most useful in the case of a header.

Flags are special markers BibleQE looks for to tell it to process the file differently. Right now the only flag is `version`.

## Word

When indexing, a word could be any group of glyphs not containing whitespace. However for the current implemenation, these glyphs are stripped out `.,;:()?!` being considered sentence punctuation, and not a part of any words.

## Index

Each (non-comment) indexing line uses this format: `<word> <frequency> <lineno>,<wordno> ...`

See the *Example* section below.

## Case-insensitive

Words are made case-insensitive by converting them to lowercase before indexing.

## Example

Given the following verse:

> "By faith we understand that the universe was formed at God's command, so that what is seen was not made out of what was visible."

BibleQE generates this index:

    ! BibleQE Index: NIV test
    ! version 1
    was 3 1,8 1,18 1,24
    that 2 1,5 1,14
    what 2 1,15 1,23