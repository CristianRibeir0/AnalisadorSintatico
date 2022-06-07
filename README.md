#AnalisadorSintatico
Para a construção da atual etapa do compilador realiza a análise do código escrito em miniC (versão simplificada do c), foi utilizado o gerador de analisador sintático YACC junto ao gerador de analisador léxico FLEX. Reconhece iteraçoes ("for" e "while", pode conter os comandos "break" e "continue"), condicçeos ("if" e "else") também reconhece declarações e atribuições para os tipos "int", "float" e "string" (uma melhoria para a linguagem C).
Para a execução do compilador é necessaria a prévia instalação do Flex e Yacc, no Linux podem ser instalador pelo comando:
"sudo apt install flex yacc"
O Compilador pode ser executado pelo comando "make all" que, por padrão analisa o arquivo "codigo01.txt", mas a entrada pode ser alterada através da edição do arquivo "makefile"
