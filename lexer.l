%{
#include <stdio.h>
#include "parser.tab.h"
void yyerror(const char *s);

static void count_newlines(const char *text) {
    const char *p = text;
    while (*p) {
        if (*p == '\n') {
            yylineno++;
        }
        p++;
    }
}
%}
%option noinput nounput

digit      [0-9]
letter     [a-zA-Z]
id         ({letter}|_)({letter}|{digit}|_)*
number     {digit}+
header     \<{id}\.h\>
string     \"([^\"\n])*\"

%%


"int"        { return INT; }
"char"       { return CHAR; }
"float"      { return FLOAT; }
"double"     { return DOUBLE; }
"while"      { return WHILE; }
"for"        { return FOR; }
"switch"     { return SWITCH; }
"case"       { return CASE; }
"default"    { return DEFAULT; }
"break"      { return BREAK; }
"do"         { return DO; }
"if"         { return IF; }
"else"       { return ELSE; }
"main"       { return MAIN; }
"#include"   { return INCLUDE; }

"//".*       ;


"/*"([^*]|\*+[^*/])*\*+"/" { count_newlines(yytext); }

"=="         { return EQCOMP; }
">="         { return GREATEREQ; }
"<="         { return LESSEREQ; }
"!="         { return NOTEQ; }
"&&"         { return ANDAND; }
"||"         { return OROR; }
"++"         { return INC; }
"--"         { return DEC; }

">"          { return *yytext; }
"<"          { return *yytext; }
"="          { return *yytext; }
"!"          { return *yytext; }
"+"          { return *yytext; }
"-"          { return *yytext; }
"*"          { return *yytext; }
"/"          { return *yytext; }


"("          { return *yytext; }
")"          { return *yytext; }
"["          { return *yytext; }
"]"          { return *yytext; }
"{"          { return *yytext; }
"}"          { return *yytext; }
";"          { return *yytext; }
","          { return *yytext; }

{string}     { return STRLITERAL; }
{number}     { return NUM; }


{header}     { return HEADER; }
{id}         { return ID; }


"\n"         { yylineno++; }
[ \t\r]+     ;


.            { return *yytext; }

%%


int yywrap() {
    return 1;
}
