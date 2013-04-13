# BibleQE Index File Specification Version 1 R1
## April 2012

## File format

The index should be in plain text format. Encoded in Unicode UTF-8 where possible.

## Overview

Each line is considered a single word's index. It then has space separated values, starting with the WORD, then its FREQUENCY, and then each OCCURANCE in the source file. There is a special case for lines at the top of the file, beginning with a `!`, which are comment or flag lines. The only required flag is `version`.

## Example

Each non-comment line of the index uses this format: `<word> <frequency> <lineno>,<wordno> ...`

For instance, for the following verse:

> "By faith we understand that the universe was formed at God's command, so that what is seen was not made out of what was visible."

Begets this (chopped) index:

    ! version 1
    was 3 1,8 1,18 1,24
    that 2 1,5 1,14
    what 2 1,15 1,23