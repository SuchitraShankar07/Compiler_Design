%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
%}

/* ----------- TOKENS (must match lexer) ----------- */

%token INT FLOAT CHAR DOUBLE
%token IF ELSE DO WHILE FOR
%token SWITCH CASE DEFAULT BREAK
%token ID NUM
%token MAIN INCLUDE INC DEC STRLITERAL HEADER
%token EQCOMP NOTEQ GREATEREQ LESSEREQ
%token ANDAND OROR

/* Precedence */
%nonassoc IFX
%nonassoc ELSE

%start program

%%

program
        : stmt_list
        ;

stmt_list
        : stmt_list statement
        | /* empty */
        ;

statement
        : declaration ';'
        | expression ';'
        | ';'
        | if_stmt
        | while_stmt
        | for_stmt
        | do_while_stmt
        | switch_stmt
        | BREAK ';'
        | block
        ;

block
        : '{' stmt_list '}'
        ;

declaration
        : type init_declarator_list
        ;

type
        : INT
        | FLOAT
        | CHAR
        | DOUBLE
        ;

init_declarator_list
        : init_declarator_list ',' init_declarator
        | init_declarator
        ;

init_declarator
        : ID array_dims_opt initializer_opt
        ;

array_dims_opt
        : /* empty */
        | array_dims_opt '[' NUM ']'
        ;

initializer_opt
        : /* empty */
        | '=' expression
        ;

if_stmt
        : IF '(' expression ')' statement %prec IFX
        | IF '(' expression ')' statement ELSE statement
        ;

while_stmt
        : WHILE '(' expression ')' statement
        ;

for_stmt
        : FOR '(' opt_for_expr_list ';' opt_for_condition ';' opt_for_expr_list ')' statement
        ;

do_while_stmt
        : DO statement WHILE '(' expression ')' ';'
        ;

opt_for_expr_list
        : /* empty */
        | for_expr_list
        ;

for_expr_list
        : for_expr_list ',' assignment_expression
        | assignment_expression
        ;

opt_for_condition
        : /* empty */
        | expression
        ;

switch_stmt
        : SWITCH '(' expression ')' '{' switch_sections_opt '}'
        ;

switch_sections_opt
        : /* empty */
        | switch_sections
        ;

switch_sections
        : switch_sections switch_section
        | switch_section
        ;

switch_section
        : CASE NUM ':' stmt_list
        | DEFAULT ':' stmt_list
        ;

expression
        : assignment_expression
        ;

assignment_expression
        : ID '=' assignment_expression
        | logical_or_expression
        ;

logical_or_expression
        : logical_or_expression OROR logical_and_expression
        | logical_and_expression
        ;

logical_and_expression
        : logical_and_expression ANDAND equality_expression
        | equality_expression
        ;

equality_expression
        : equality_expression EQCOMP relational_expression
        | equality_expression NOTEQ relational_expression
        | relational_expression
        ;

relational_expression
        : relational_expression '<' additive_expression
        | relational_expression '>' additive_expression
        | relational_expression GREATEREQ additive_expression
        | relational_expression LESSEREQ additive_expression
        | additive_expression
        ;

additive_expression
        : additive_expression '+' multiplicative_expression
        | additive_expression '-' multiplicative_expression
        | multiplicative_expression
        ;

multiplicative_expression
        : multiplicative_expression '*' unary_expression
        | multiplicative_expression '/' unary_expression
        | unary_expression
        ;

unary_expression
        : '!' unary_expression
        | '+' unary_expression
        | '-' unary_expression
        | postfix_expression
        ;

postfix_expression
        : postfix_expression INC
        | postfix_expression DEC
        | primary_expression
        ;

primary_expression
        : '(' expression ')'
        | ID
        | NUM
        ;

%%

void yyerror(const char *s)
{
    fprintf(stderr,
            "Syntax error at line %d, token '%s': %s\n",
            yylineno,
            yytext,
            s);
}

int main()
{
    if (yyparse() == 0)
        printf("Syntax valid.\n");
    return 0;
}
