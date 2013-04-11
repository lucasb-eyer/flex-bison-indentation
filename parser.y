/*
Copyright (C) 2013 Lucas Beyer (http://lucasb.eyer.be)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

%{
#include <cstdio>
#include <iostream>

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

void yyerror(const char *s);

static const char* black   = "\033[0;30m";
static const char* red     = "\033[0;31m";
static const char* green   = "\033[0;32m";
static const char* yellow  = "\033[0;33m";
static const char* blue    = "\033[0;34m";
static const char* magenta = "\033[0;35m";
static const char* cyan    = "\033[0;36m";
static const char* white   = "\033[0;37m";
static const char* fg      = "\033[0;39m";

#define YYSTYPE int
%}

%token TOK_INDENT
%token TOK_OUTDENT

%token TOK_STUFF TOK_REST

%locations

 /* %debug */

%%
root:
    root stuff | stuff ;

stuff:
     TOK_STUFF { std::cout << red << "stuff" << fg << "(" << @1.first_line << ":" << @1.first_column << "-" << @1.last_column << ")" << std::endl; }
     |
     TOK_STUFF TOK_REST { std::cout << red << "stuff" << fg << "(" << @1.first_line << ":" << @1.first_column << "-" << @1.last_column << ") " << red << "with rest" << fg << "(" << @2.first_line << ":" << @2.first_column << "-" << @2.last_column << ")" << std::endl; }
     |
     TOK_INDENT { std::cout << green << "indent" << fg << "(" << @1.first_line << ":" << @1.first_column << "-" << @1.last_column << ")" << std::endl; }
     |
     TOK_OUTDENT { std::cout << green << "outdent" << fg << "(" << @1.first_line << ":" << @1.first_column << "-" << @1.last_column << ")" << std::endl; }
    ;

%%

const char* g_current_filename = "stdin";

int main(int argc, char* argv[]) {
    yyin = stdin;
#if YYDEBUG
    yydebug = 1;
#endif

    if(argc == 2) {
        yyin = fopen(argv[1], "r");
        g_current_filename = argv[1];
        if(!yyin) {
            perror(argv[1]);
            return 1;
        }
    }

    // parse through the input until there is no more:
    do {
        yyparse();
    } while (!feof(yyin));

    // Only in newer versions, apparently.
    // yylex_destroy();
}

void yyerror(const char *s) {
    std::cerr << g_current_filename << ":" << yylloc.first_line << ":" << yylloc.first_column << "-" << yylloc.last_column << ": Parse error: " << s << std::endl;
    exit(-1);  // Might as well halt now.
}

