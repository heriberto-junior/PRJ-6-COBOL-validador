       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDADOR.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-TIPO-DOC        PIC X(10).
       01  WS-NUMERO          PIC X(20).
       01  WS-NUMERO-LIMPO    PIC X(20).
       01  WS-RESULTADO       PIC X(10).
       01  WS-ARGS            PIC X(100).
       01  WS-POS             PIC 9(3).
       01  WS-SPACE-POS       PIC 9(3).
       01  WS-CHAR            PIC X(1).
       01  WS-TAMANHO         PIC 9(2).
       01  WS-TAMANHO-LIMPO   PIC 9(2).
       01  WS-POS-LIMPO       PIC 9(2).
       01  WS-NUMERO-FORMAT   PIC X(20).
       
       PROCEDURE DIVISION.
           ACCEPT WS-ARGS FROM COMMAND-LINE.
           
      *    Extrair argumentos
           MOVE 1 TO WS-POS.
           MOVE FUNCTION TRIM(WS-ARGS) TO WS-ARGS.
           
           PERFORM VARYING WS-SPACE-POS FROM 1 BY 1
               UNTIL WS-SPACE-POS > FUNCTION LENGTH(WS-ARGS)
               IF WS-ARGS(WS-SPACE-POS:1) = SPACE
                   MOVE WS-ARGS(1:WS-SPACE-POS - 1) TO WS-TIPO-DOC
                   MOVE WS-ARGS(WS-SPACE-POS + 1:) TO WS-NUMERO
                   MOVE FUNCTION LENGTH(WS-ARGS) TO WS-SPACE-POS
               END-IF
           END-PERFORM.
           
           IF WS-TIPO-DOC = SPACES
               MOVE WS-ARGS TO WS-TIPO-DOC
           END-IF.
           
           MOVE FUNCTION LOWER-CASE(WS-TIPO-DOC) TO WS-TIPO-DOC.
           MOVE FUNCTION TRIM(WS-NUMERO) TO WS-NUMERO.
           
      *    ===== LIMPAR CARACTERES ESPECIAIS =====
           MOVE 0 TO WS-POS-LIMPO.
           MOVE SPACES TO WS-NUMERO-LIMPO.
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-NUMERO)) 
               TO WS-TAMANHO.
           
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > WS-TAMANHO
               MOVE WS-NUMERO(WS-POS:1) TO WS-CHAR
               IF WS-CHAR NUMERIC
                   ADD 1 TO WS-POS-LIMPO
                   MOVE WS-CHAR TO WS-NUMERO-LIMPO(WS-POS-LIMPO:1)
               END-IF
           END-PERFORM.
           
           MOVE WS-NUMERO-LIMPO TO WS-NUMERO.
           
           EVALUATE WS-TIPO-DOC
               WHEN "cpf"
                   CALL "VALIDAR-CPF" USING WS-NUMERO 
                       BY REFERENCE WS-RESULTADO
               WHEN "cnpj"
                   CALL "VALIDAR-CNPJ" USING WS-NUMERO 
                       BY REFERENCE WS-RESULTADO
               WHEN OTHER
                   DISPLAY "ERRO: Tipo de documento invalido!"
                   DISPLAY "Opcoes: cpf, cnpj"
                   STOP RUN RETURNING 0
           END-EVALUATE.
           
      *    ===== FORMATAR SAIDA =====
           EVALUATE WS-RESULTADO
               WHEN "VALIDO"
                   EVALUATE WS-TIPO-DOC
                       WHEN "cpf"
                           PERFORM FORMATAR-CPF
                       WHEN "cnpj"
                           PERFORM FORMATAR-CNPJ
                   END-EVALUATE
                   
                   DISPLAY "========================================="
                   DISPLAY "DOCUMENTO VALIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " FUNCTION UPPER-CASE(WS-TIPO-DOC)
                   DISPLAY "Numero: " WS-NUMERO-FORMAT
                   DISPLAY "Status: APROVADO"
                   DISPLAY "========================================="
               WHEN "INVALIDO"
                   DISPLAY "========================================="
                   DISPLAY "DOCUMENTO INVALIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " FUNCTION UPPER-CASE(WS-TIPO-DOC)
                   DISPLAY "Numero: " WS-NUMERO
                   DISPLAY "Status: REJEITADO"
                   DISPLAY "========================================="
               WHEN OTHER
                   DISPLAY "Erro desconhecido"
           END-EVALUATE.
           
           STOP RUN RETURNING 0.
       
       FORMATAR-CPF.
      *    Formata CPF no padrao: XXX.XXX.XXX-XX
           MOVE SPACES TO WS-NUMERO-FORMAT.
           
           STRING 
               WS-NUMERO(1:3) DELIMITED BY SIZE
               "." DELIMITED BY SIZE
               WS-NUMERO(4:3) DELIMITED BY SIZE
               "." DELIMITED BY SIZE
               WS-NUMERO(7:3) DELIMITED BY SIZE
               "-" DELIMITED BY SIZE
               WS-NUMERO(10:2) DELIMITED BY SIZE
               INTO WS-NUMERO-FORMAT
           END-STRING.
       
       FORMATAR-CNPJ.
      *    Formata CNPJ no padrao: XX.XXX.XXX/XXXX-XX
           MOVE SPACES TO WS-NUMERO-FORMAT.
           
           STRING 
               WS-NUMERO(1:2) DELIMITED BY SIZE
               "." DELIMITED BY SIZE
               WS-NUMERO(3:3) DELIMITED BY SIZE
               "." DELIMITED BY SIZE
               WS-NUMERO(6:3) DELIMITED BY SIZE
               "/" DELIMITED BY SIZE
               WS-NUMERO(9:4) DELIMITED BY SIZE
               "-" DELIMITED BY SIZE
               WS-NUMERO(13:2) DELIMITED BY SIZE
               INTO WS-NUMERO-FORMAT
           END-STRING.
