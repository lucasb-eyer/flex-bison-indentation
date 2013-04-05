flex-bison-indentation
======================

An example of how to correctly parse python-like indentation-scoped files using flex (and bison).

Besides that, this project also serves as a template CMake-based project for a flex&bison parser
and includes rules to track the current line and column of the scanner.

Quick overview
==============

All the magic happens in the scanner, which emits `TOK_INDENT` and `TOK_OUTDENT` tokens whenever
the level of indentation increases or decreases. The parser in this project just echoes the tokens.

The scanner includes the `<normal>` mode which it starts in. That's where you
put your regular rules. Whenever a newline is encountered in that mode, the
parser enters the `<indent>` mode, in which it keeps counting the spaces and
tabs (and ignoring blank lines) until it sees anything else, in which case it
outputs either a `TOK_INDENT`, one or more `TOK_OUTDENT` as necessary or none
of these tokens and goes back to `<normal>` mode.

The scanner also does its best to keep track of the column where the current
match starts, which can be accessed (and changed) through `yycolumn`. The line
number is kept track of by flex internally.

All of this means that you can write the parser as usual, make use of the
`TOK_INDENT` and `TOK_OUTDENT` tokens in order to handle indentation and access
the current line of tokens through `@1.first_line` (and `@1.last_line` if the
token spans multiple lines, which I don't recommend.) and the column range of it
through `@1.first_column` and `@1.last_column`.

One caveat is that if one of your rules includes a newline character and is
matches text longer than one symbol, you will need to reset `yycolumn` by hand.

Another one is that, for technical reasons, the column-range of the
`TOK_INDENT` and `TOK_OUTDENT` tokens is the first character of the line or,
for outdents happening through reaching the end of the file, `0-0`.

Until I write a full tutorial, I recommend you look at the code, it is short and fully commented.
