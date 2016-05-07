# tablerator

## Times Tables Owl Tests

Our kids are doing a Times Tables Owl challenge, no idea if this is 
unique to their school, or a national thing. 
Either way this should generate useful tests for times tables and goes beyond
the basics.

You could probably find something better on-line, but I wanted to produce
something bespoke.

## Description

This is a simple attempt to create times tables tests for my children 
It has three levels:

 1. Bronze Owl: Basic times tables
 2. Silver Owl: Have to calculate one of the factors from the answer
 3. Gold Owl: Includes squares, square roots and multiple factors on
 both sides.

These are set in the user variables at the top of the program. 
Time permitting I may improve this to have command line switches.

Creates a PDF named tables.pdf, via an interim tables.md markdown file. 
Basically I am using markdown as an easy way to produce a PDF.

## Road Map

Transfer of user variables into command-line switches.
Gold owl testing is only three quarters complete.

## Requirements

Currently requires pandoc to convert a text markdown file into a PDF.
