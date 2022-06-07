%{
#include <iostream>
#include <string>
using namespace std;
#include <sstream>

#define YYSTYPE atributos

struct atributos
{
        string label;
        string traducao;
};

int linha = 1;
int coluna = 1;

int yylex(void);
void yyerror(string);


%}
%start CODIGO
%token EOL COMENT SEP RES ID TIPO_INT TIPO_FLOAT TIPO_STRING INT FLOAT LIT OP_ARIT OP_LOGI
    IF ELSE FOR WHILE BREAK CONTINUE OP_INC OP_DEC
%left SOMA

%% 
    CODIGO: BLOCO
    ;
    BLOCO: CODS 
    {
        cout << "Rodou" << endl;
    }
    ;

    CODS: COD_ CODS
        |
        ;

    COD_:
        {
        cout << "Rodando Linhas" << endl;
        }
        DEC ';'
        {cout << "\n@@DECLARACAO\n" << endl;}
        |
        AT ';'
        {cout << "\n@@ATRIBUICAO\n" << endl;}
        |
        COND 
        {cout << "\n@@CONDICAO\n" << endl;}
        |
        ITER
        ;

    AT:
        ID '=' EXP
        |
        ID '=' LIT
        |
        ID OP_INC
        |
        ID OP_DEC
        ;

    EXP:
        T EXP_ 
        ;

    EXP_: '+' T EXP_
        | '-' T EXP_
        |
        ;

    T: F T_
        ;

    T_: '*' F T_
        |
        '/' F T_
        |
        ;
    F: '(' EXP ')'
        |
        ID
        |
        INT
        |
        FLOAT
        ;
    DEC:
        TIPO_INT DEC_
            {cout << "\nTipo int\n"<< endl;} 
        |
        TIPO_FLOAT DEC_
            {cout << "\nTipo float\n"<< endl;} 
        |
        TIPO_STRING ID '=' LIT
            {cout << "\nTipo string\n"<< endl;}
        |
        TIPO_STRING ID 
        ;
    DEC_: ID
        |
        AT
        ;

    COND: COND_ COND
    {cout << "Merrrrrrda"<< endl;} 
        |
    ;

    COND_: IF '(' F OP_LOGI F ')' '{' BLOCO_COND
            |
            IF '(' F OP_LOGI F ')' '{' BLOCO_COND ELSE '{' BLOCO_COND
    {cout << "heydasdsad" <<endl;}
    ;

    BLOCO_COND: BLOCO_COND_ '}'
        |
        '}'
    ;

    BLOCO_COND_: CONTINUE ';' BLOCO_COND_
        |
        BREAK ';' BLOCO_COND_
        |
        BLOCO CONTINUE ';' BLOCO_COND_
        |
        BLOCO BREAK ';' BLOCO_COND_
        |
        BLOCO

    ITER: LFOR
        |
        LWHILE


    LFOR: FOR '(' AT ';' F OP_LOGI F  ';' AT ')' '{' BLOCO_ITER
        |
        FOR '(' DEC ';' F OP_LOGI F ';' AT ')' '{' BLOCO_ITER
    {cout << "heydasdsad" <<endl;}
    ;

    BLOCO_ITER: BLOCO_ITER_ '}'
        |
        '}'
    ;

    BLOCO_ITER_: CONTINUE ';' BLOCO_ITER_
        |
        BREAK ';' BLOCO_ITER_
        |
        BLOCO CONTINUE ';' BLOCO_ITER_
        |
        BLOCO BREAK ';' BLOCO_ITER_
        |
        BLOCO

    LWHILE: WHILE '('  VAR_T OP_LOGI VAR_T ')' '{' BLOCO_ITER
         
    ;
    
    VAR_T: INT
        |
        FLOAT
        |
        ID
        |
        LIT
    ;






    
; 
%%
#include "lex.yy.c"
int yyparse();

int main(int argc, char** argv){
    yyparse();
    return 0;
}

void yyerror(string MSG){
    cout << "Erro sintatico. Linha: " << linha << " Coluna: " << coluna << endl;
}
