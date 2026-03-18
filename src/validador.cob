       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDADOR.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.
       
       WORKING-STORAGE SECTION.
       01  WS-TIPO-DOC        PIC X(10).
       01  WS-NUMERO          PIC X(20).
       01  WS-RESULTADO       PIC X(10).
       01  WS-RETURN-CODE     PIC 9(3) VALUE 0.
       
       PROCEDURE DIVISION.
           ACCEPT WS-TIPO-DOC FROM ARGUMENT VALUE 1.
           ACCEPT WS-NUMERO FROM ARGUMENT VALUE 2.
           
           EVALUATE WS-TIPO-DOC
               WHEN "cpf"
                   CALL "VALIDAR-CPF" USING WS-NUMERO 
                       RETURNING WS-RESULTADO
               WHEN "cnpj"
                   CALL "VALIDAR-CNPJ" USING WS-NUMERO 
                       RETURNING WS-RESULTADO
               WHEN "ie"
                   CALL "VALIDAR-IE" USING WS-NUMERO 
                       RETURNING WS-RESULTADO
               WHEN OTHER
                   DISPLAY "ERRO: Tipo de documento inválido!"
                   DISPLAY "Opções: cpf, cnpj, ie"
                   MOVE 1 TO WS-RETURN-CODE
                   STOP RUN
           END-EVALUATE.
           
           EVALUATE WS-RESULTADO
               WHEN "VALIDO"
                   DISPLAY "========================================="
                   DISPLAY "✓ DOCUMENTO VÁLIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " WS-TIPO-DOC
                   DISPLAY "Número: " WS-NUMERO
                   DISPLAY "Status: APROVADO"
                   DISPLAY "========================================="
                   MOVE 0 TO WS-RETURN-CODE
               WHEN "INVALIDO"
                   DISPLAY "========================================="
                   DISPLAY "✗ DOCUMENTO INVÁLIDO"
                   DISPLAY "========================================="
                   DISPLAY "Tipo: " WS-TIPO-DOC
                   DISPLAY "Número: " WS-NUMERO
                   DISPLAY "Status: REJEITADO"
                   DISPLAY "========================================="
                   MOVE 1 TO WS-RETURN-CODE
           END-EVALUATE.
           
           STOP RUN RETURNING WS-RETURN-CODE.
