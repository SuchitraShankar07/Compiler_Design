%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
extern char *yytext;
int had_error = 0;

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
        : include_list_opt external_list
        ;

external_list
        : external_list external
        | /* empty */
        ;

external
        : statement
        | main_function
        ;

include_list_opt
        : /* empty */
        | include_list
        ;

include_list
        : include_list include_stmt
        | include_stmt
        ;

include_stmt
        : INCLUDE HEADER
        | INCLUDE STRLITERAL
        ;

main_function
        : type MAIN '(' parameter_list_opt ')' block
        ;

parameter_list_opt
        : /* empty */
        | parameter_list
        ;

parameter_list
        : parameter_list ',' parameter
        | parameter
        ;

parameter
        : type ID
        | type
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
        | error ';' { yyerrok; }
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
    had_error = 1;
    fprintf(stderr,
            "Error: %s, line number: %d,token: %s\n",
            s, yylineno, yytext);
}

int main()
{
    if (yyparse() == 0 && !had_error)
        printf("Valid syntax\n");
    return 0;
}
