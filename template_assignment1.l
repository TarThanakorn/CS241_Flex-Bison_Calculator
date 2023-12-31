%{
//6409610620 Thanakorn Chairattanathananon
#include <stdio.h>
#include <string.h>
#include "template_assignment1.tab.h"
void showError(char *str) ;    
%}
numbers [0-9]+
alpha   [A-Za-z$_][A-Za-z0-9$_]*
%option yylineno
%%
{alpha}	{
    sscanf(yytext, "%s", yylval.name) ;
    return(IDENT) ;}
{numbers}   {
    int length = strlen(yytext) ;
    yylval.number = atoi(yytext) ;
    if (length <=4 && yylval.number >=0 && yylval.number <=9999){
        return(NUMBER);
    }
    else
        printf("Error: Number must be >=0 and <=9999. Your entered number = %s \n", yytext) ;
}
"+"         return ADD;
"-"         return SUB;
"*"         return MUL;
"/"         return DIV;
"("         return OPARENT;
")"         return CPARENT;
[ \t]+      ;
.           {showError("Input ไม่ถูกต้อง"); return(OTHER) ;}
\n	        return END;
%%
int yywrap(){}
void showError(char *str){
    fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str);
}
