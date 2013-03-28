flex-bison-indentation
======================

An example of how to correctly parse python-like indentation-scoped files using flex (and bison).

Besides that, this project also serves as a template CMake-based project for a flex&bison parser
and includes rules to track the current line and column of the scanner.

Quick overview
==============

All the magic happens in the scanner, which emits `TOK_INDENT` and `TOK_OUTDENT` tokens whenever
the level of indentation increases or decreases. The parser in this project just echoes the tokens.

The scanner includes the `<indent>` mode which it starts in. In this mode, it counts the the spaces
(and tabs) up to the first non-space character and compares them to the current indentation level.
If it's the same, nothing happens and scanning goes on in the `<normal>` mode. If the indentation
has changed, the stack keeping track of it is updated and either one `TOK_INDENT` token is emitted,
or as many `TOK_OUTDENT`s as necessary are emitted.

All of this means that you can write the parser as usual and also make use of the `TOK_INDENT` and
`TOK_OUTDENT` tokens in order to handle indentation.

Until I write a full tutorial, I recommend you look at the code, it is short and fully commented.
