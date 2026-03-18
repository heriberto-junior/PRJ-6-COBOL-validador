       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDADOR.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-TIPO-DOC        PIC X(10).
       01  WS-NUMERO          PIC X(20).
       01  WS-RESULTADO       PIC X(10).
       01  WS-ARGS            PIC X(100).
       01  WS-POS             PIC 9(3).
       01  WS-SPACE-POS       PIC 9(3).
       
       PROCEDURE DIVISION.
           ACCEPT WS-ARGS FROM COMMAND-LINE.
           
      *    Extrair primeiro argumento (tipo)
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
           
           EVALUATE WS-TIPO-DOC
               WHEN "cpf"
                   CALL "VALIDAR-CPF" USING WS-NUMERO 
                       BY REFERENCE WS-RESULTADO
               WHEN "cnpj"
                   CALL "VALIDAR-CNPJ" USING WS-NUMERO 
                       BY REFERENCE WS-RESULTADO
               WHEN "ie"
                   CALL "VALIDAR-IE" USING WS-NUMERO 
                       BY REFERENCE WS-RESULTADO
               WHEN OTHER
                   DISPLAY "ERRO: Tipo de documento inválido!"
                   DISPLAY "Opções: cpf, cnpj, ie"
                   STOP RUN RETURNING 1
           END-EVALUATE.
           
           EVALUATE WS-RESULTADO
               WHEN "VALIDO"
                   DISPLAY "========================================="
                   DISPLAY "✓ DOCUMENTO VÁLIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " FUNCTION UPPER-CASE(WS-TIPO-DOC)
                   DISPLAY "Número: " WS-NUMERO
                   DISPLAY "Status: APROVADO"
                   DISPLAY "========================================="
                   STOP RUN RETURNING 0
               WHEN "INVALIDO"
                   DISPLAY "========================================="
                   DISPLAY "✗ DOCUMENTO INVÁLIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " FUNCTION UPPER-CASE(WS-TIPO-DOC)
                   DISPLAY "Número: " WS-NUMERO
                   DISPLAY "Status: REJEITADO"
                   DISPLAY "========================================="
                   STOP RUN RETURNING 1
               WHEN OTHER
                   DISPLAY "Erro desconhecido"
                   STOP RUN RETURNING 1
           END-EVALUATE.
