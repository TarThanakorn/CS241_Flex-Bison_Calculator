%{
//6409610620 Thanakorn Chairattanathananon
#include <stdio.h>
#include <string.h>
extern int yylineno;
typedef struct node1 {
     char *name ;
     struct node1 *next ;
} NODE1 ;
typedef struct node2 {
     int number ;
     struct node2 *next ;
} NODE2 ;
typedef struct node3 {
     char operator ;
     struct node3 *next ;
} NODE3 ;

int yylex();
int yyerror(char *s) ;
void printListOfIdents(NODE1 *l1) ;
void printListOfNumbers(NODE2 *l2) ;
void printListOfOperators(NODE3 *l3) ;

NODE1 *list1,*head1 = NULL ;
NODE2 *list2,*head2 = NULL ;
NODE3 *list3,*head3 = NULL ;

%}
%token IDENT NUMBER OTHER ADD SUB MUL DIV END OPARENT CPARENT

%type <name> IDENT
%type <number> NUMBER
%type <operator> ADD SUB MUL DIV OPARENT CPARENT
%union{
    char name[20] ;
    int number ;
    char operator;
}

%start exp /*start symbol for the grammar */
%%
exp: exps END;
exps: term expprime;
expprime: ADD term expprime {
    printf("OPERATOR: +\n");
    NODE3 *elm = (NODE3 *) malloc(sizeof(NODE3)) ;
    elm->operator = '+';
    if (list3 == NULL){
        list3 = elm;
	head3 = list3;
    }else{
        list3->next = elm;
        list3 = list3->next;
    }
} | SUB term expprime {
    printf("OPERATOR: -\n");
    NODE3 *elm = (NODE3 *) malloc(sizeof(NODE3)) ;
    elm->operator = '-';
    if (list3 == NULL){
        list3 = elm;
	head3 = list3;
    }else{
        list3->next = elm;
        list3 = list3->next;
    }
} | {};

term: factor termprime;
termprime: MUL factor termprime{
    printf("OPERATOR: *\n");
    NODE3 *elm = (NODE3 *) malloc(sizeof(NODE3)) ;
    elm->operator = '*';
    if (list3 == NULL){
        list3 = elm;
        head3 = list3;
    }else{
        list3->next = elm;
        list3 = list3->next;
    }
}| DIV factor termprime{
    printf("OPERATOR: /\n");
    NODE3 *elm = (NODE3 *) malloc(sizeof(NODE3)) ;
    elm->operator = '/';
    if (list3 == NULL){
        list3 = elm;
        head3 = list3;
    }else{
        list3->next = elm;
        list3 = list3->next;
    }
}| {};

factor: IDENT{
    printf("IDENTIFIER: %s FOUND \n", $1) ;
    NODE1 *elm = (NODE1 *) malloc(sizeof(NODE1)) ;
    elm->name = malloc(sizeof($1)) ;
    strcpy(elm->name, $1);
    if (list1 == NULL){
        list1 = elm;
	head1 = list1;
    }else{
        list1->next = elm;
        list1 = list1->next;
    }
}| NUMBER{
    printf("NUMBER: %d FOUND \n", yylval.number) ;
    NODE2 *elm = (NODE2 *) malloc(sizeof(NODE2)) ;
    elm->number = $1;
    if (list2 == NULL){
        list2 = elm ;
	head2 = list2;
    }else{
        list2->next = elm;
	list2 = list2->next;
    }
}| OPARENT exp CPARENT;
| SUB NUMBER{
    printf("NUMBER: -%d FOUND \n", yylval.number) ;
    NODE2 *elm = (NODE2 *) malloc(sizeof(NODE2)) ;
    elm->number = $2 * -1;
    if (list2 == NULL){
        list2 = elm ;
	head2 = list2;
    }else{
        list2->next = elm;
	list2 = list2->next;
    }
}

%%
int yyerror(char *s){
    printf("Syntax Error: %s on Line %d \n", s, yylineno) ;
    return 0 ;
}

void printListOfIdents(NODE1 *l1){
    NODE1 *ptr = l1 ;
    printf("Linked list 1: ");
    while (ptr != NULL){
        printf("%s -> ", ptr->name);
        ptr = ptr->next ;
    }
    printf("NULL \n");
}

void printListOfNumbers(NODE2 *l2){
    NODE2 *ptr = l2 ;
    printf("Linked list 2: ");
    while (ptr != NULL){
	if(ptr->number > 0)
            printf("%d -> ", ptr->number);
	else
	    printf("(%d) -> ", ptr->number);
        ptr = ptr->next ;
    }
    printf("NULL \n");
}

void printListOfOperators(NODE3 *l3){
    NODE3 *ptr = l3 ;
    int add = 1;
    int sub = 1;
    int mul = 1;
    int div = 1;
    printf("Linked list 3: ");
    while (ptr != NULL){
	switch(ptr->operator){
	    case '+':
		if(add){
                    printf("%c -> ", ptr->operator);
		    add = 0;
		}
		break;
	    case '-':
                if(sub){
                    printf("%c -> ", ptr->operator);
                    sub = 0;
                }
		break;
            case '*':
                if(mul){
                    printf("%c -> ", ptr->operator);
                    mul = 0;
                }
		break;
            case '/':
                if(div){
                    printf("%c -> ", ptr->operator);
                    div = 0;
                }
		break;
         }
         ptr = ptr->next ;
    }
    printf("NULL \n");
}

int main(){
    yyparse();
    printf("All Linked list:\n");
    if (list1!=NULL) {
        printListOfIdents(head1) ;
    }
    if (list2!=NULL) {
        printListOfNumbers(head2) ;
    }
    if (list3!=NULL) {
        printListOfOperators(head3) ;
    }
    return 0 ;
}
