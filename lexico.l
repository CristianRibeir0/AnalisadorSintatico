
%{
#include "y.tab.h"
#include "string.h"


#define MAX_ERROS 20

void yyerror(char* c);
void adc_tabela(char* tk, char* val);
void adc_erro(char erro,int c_atual);
void persiste_tabela();
void persiste_erros();

typedef struct Obj{
    int lin;
    int col;
    char* token;
    char* valor;
    struct Obj* prox;
}obj;

typedef struct Err{
    char* c_erro;
    int lin;
    int col;
}err;

obj* tabela;
obj** aux;
err* erros;
int n_erros = 0;
int pos_sep;

%}

EOL [;]
TIPO (int|float|string)
RESERVADA (if|else|for|while|break|continue)
INTEIRO [0-9]+
LETRA [a-zA-Z]
LITERAL \"[^\"]*\"
FLOAT {INTEIRO}"."{INTEIRO}
IDENTIFICADOR {LETRA}({LETRA}|{INTEIRO})*
COMENTARIO1 (\/\/.*)
COMENTARIO ("/*"((("*"[^/])?)|[^*])*"*/")
OP_INC {OP_SUM}{OP_SUM}
OP_MOD [%]
OP_SUM [+]
OP_SUB [-]
OP_DEC ({OP_SUB}{OP_SUB})
OP_MUL [*]
OP_DIV \/
OP_POW [**]
OP_EQ [=] 
OP_AND [&&]
OP_OR \|\|
OP_MA [\>]
OP_MI [<]
OP_MAEQ {OP_MA}{OP_EQ}
OP_MIEQ {OP_MI}{OP_EQ}
OP_EQEQ {OP_EQ}{OP_EQ}
OP_LOGI({OP_MAEQ}|{OP_MIEQ}|{OP_EQEQ}|{OP_AND}|{OP_OR}|{OP_MA}|{OP_MI})
OP_ARIT({OP_EQ}|{OP_MOD}|{OP_INC}|{OP_DEC}|{OP_SUM}|{OP_SUB}|{OP_MUL}|{OP_DIV})
ESP [\ ]
SEPARADOR [\ \t\n,;}{\(\)]
SEPARADOR_OP({SEPARADOR}|{FLOAT}|{INTEIRO}|{LETRA})
SEPARADOR_NUM({SEPARADOR}|{OP_ARIT}|{OP_LOGI})
ERROR .
%%
\n {coluna=1;linha++;}



{ESP} {coluna++;}
{SEPARADOR} {
    coluna++;
    return *yytext;
}

{COMENTARIO} {
    coluna+=strlen(yytext); 
}

{TIPO}/{SEPARADOR} {
    if(strcmp(yytext, "int") == 0){return TIPO_INT;}
    if(strcmp(yytext, "float") == 0){return TIPO_FLOAT;}
    if(strcmp(yytext, "string") == 0){return TIPO_STRING;}
    return TIPO_FLOAT;
}

{RESERVADA}/{SEPARADOR} {
    if(strcmp(yytext, "if") == 0){return IF;}
    if(strcmp(yytext, "else") == 0){return ELSE;}
    if(strcmp(yytext, "for") == 0){return FOR;}
    if(strcmp(yytext, "while") == 0){return WHILE;}
    if(strcmp(yytext, "break") == 0){return BREAK;}
    if(strcmp(yytext, "continue") == 0){return CONTINUE;}
}

{IDENTIFICADOR}/{SEPARADOR_NUM} {   
    yylval.label = yytext;
    coluna+=strlen(yytext);
    return ID; }


{INTEIRO}/{SEPARADOR_NUM} {
    yylval.traducao = yytext;
    coluna+=strlen(yytext);
    return INT;
}

{FLOAT}/{SEPARADOR_NUM} {
    yylval.traducao = yytext;
    coluna+=strlen(yytext);
    return FLOAT;
}

{LITERAL}/{SEPARADOR} {  
    yylval.traducao = yytext;
    coluna+=strlen(yytext);
    return LIT;
}   
{OP_ARIT}/{SEPARADOR_OP} {  
    yylval.traducao = yytext;
    coluna+=strlen(yytext);
    if(strcmp(yytext, "++") == 0){return OP_INC;}
    if(strcmp(yytext, "--") == 0){return OP_DEC;}
    return *yytext;
}
{OP_LOGI}/{SEPARADOR_OP} {
    yylval.traducao = yytext;
    coluna+=strlen(yytext);
    return OP_LOGI;
}


. {printf("\nErro LEXICO: '%s'. Linha: %d Coluna: %d\n", yytext, linha, coluna); coluna+=1;}
%%


int yywrap(){
    return 1;
}

