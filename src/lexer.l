%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tokens = 0;
int erros  = 0;

#define CAT_PALAVRA_RESERVADA "PALAVRA_RESERVADA"
#define CAT_ID_ESTUFA         "ID_ESTUFA"
#define CAT_INTEIRO           "INTEIRO"
#define CAT_ABRE_PAR          "ABRE_PAR"
#define CAT_FECHA_PAR         "FECHA_PAR"
#define CAT_ABRE_CHAVETA      "ABRE_CHAVETA"
#define CAT_FECHA_CHAVETA     "FECHA_CHAVETA"
#define CAT_VIRGULA           "VIRGULA"
#define CAT_PONTO_VIRG        "PONTO_VIRG"
#define CAT_MENOR             "MENOR"
#define CAT_MENOR_IGUAL       "MENOR_IGUAL"
#define CAT_MAIOR             "MAIOR"
#define CAT_MAIOR_IGUAL       "MAIOR_IGUAL"
#define CAT_IGUAL             "IGUAL"
#define CAT_DIFERENTE         "DIFERENTE"
#define CAT_ERRO              "ERRO_LEXICO"

void emitir(const char* cat, const char* lexema);
void erro_lexico(const char* lexema);
%}

%option noyywrap
%option yylineno
%option nodefault

MAIUSCULA   [A-Z]
ALGARISMO   [0-9]
LETRA_DIG_HIFEN_USCORE [A-Za-z0-9_-]

ID_ESTUFA   EST-{MAIUSCULA}{2}{ALGARISMO}{2}
INTEIRO     0|[1-9]{ALGARISMO}*
CANDIDATO   {LETRA_DIG_HIFEN_USCORE}+

%%

"#"[^\n\r]*               { /* ignora comentario */ }
\r\n                      { yylineno++; }
\n                        { /* yylineno auto */ }
[ \t]+                    { /* ignora espacos/tabs */ }

LIGAR                     { emitir(CAT_PALAVRA_RESERVADA, yytext); }
DESLIGAR                  { emitir(CAT_PALAVRA_RESERVADA, yytext); }
ABRIR                     { emitir(CAT_PALAVRA_RESERVADA, yytext); }
FECHAR                    { emitir(CAT_PALAVRA_RESERVADA, yytext); }
AQUECER                   { emitir(CAT_PALAVRA_RESERVADA, yytext); }
PARAR                     { emitir(CAT_PALAVRA_RESERVADA, yytext); }
REGAR                     { emitir(CAT_PALAVRA_RESERVADA, yytext); }
ESPERAR                   { emitir(CAT_PALAVRA_RESERVADA, yytext); }
SE                        { emitir(CAT_PALAVRA_RESERVADA, yytext); }
SENAO                     { emitir(CAT_PALAVRA_RESERVADA, yytext); }
HUMIDADE                  { emitir(CAT_PALAVRA_RESERVADA, yytext); }
REPETIR                   { emitir(CAT_PALAVRA_RESERVADA, yytext); }

{ID_ESTUFA}               { emitir(CAT_ID_ESTUFA, yytext); }

{INTEIRO}                 { emitir(CAT_INTEIRO, yytext); }

"<="                      { emitir(CAT_MENOR_IGUAL, yytext); }
">="                      { emitir(CAT_MAIOR_IGUAL, yytext); }
"=="                      { emitir(CAT_IGUAL, yytext); }
"!="                      { emitir(CAT_DIFERENTE, yytext); }
"<"                       { emitir(CAT_MENOR, yytext); }
">"                       { emitir(CAT_MAIOR, yytext); }

"("                       { emitir(CAT_ABRE_PAR, yytext); }
")"                       { emitir(CAT_FECHA_PAR, yytext); }
"{"                       { emitir(CAT_ABRE_CHAVETA, yytext); }
"}"                       { emitir(CAT_FECHA_CHAVETA, yytext); }
","                       { emitir(CAT_VIRGULA, yytext); }
";"                       { emitir(CAT_PONTO_VIRG, yytext); }

{CANDIDATO}               { erro_lexico(yytext); }

.                         { erro_lexico(yytext); }

<<EOF>>                   { /* fim de ficheiro */ }

%%

void emitir(const char* cat, const char* lexema) {
    printf("%d %s %s\n", yylineno, cat, lexema);
    tokens++;
}

void erro_lexico(const char* lexema) {
    printf("%d %s %s\n", yylineno, CAT_ERRO, lexema);
    erros++;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <ficheiro.gs>\n", argv[0]);
        return 1;
    }
    FILE* f = fopen(argv[1], "r");
    if (!f) {
        perror("Erro ao abrir ficheiro");
        return 1;
    }
    yyin = f;
    yylex();
    fclose(f);
    printf("Tokens: %d | Erros lexicais: %d\n", tokens, erros);
    return 0;
}