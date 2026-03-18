       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDAR-CNPJ.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CNPJ            PIC X(14).
       01  WS-SOMA            PIC 9(5) VALUE 0.
       01  WS-RESTO           PIC 9(2) VALUE 0.
       01  WS-POS             PIC 9(2).
       01  WS-CHAR            PIC X(1).
       01  WS-NUM             PIC 9(2).
       01  WS-DV1             PIC 9(1).
       01  WS-DV2             PIC 9(1).
       01  WS-TEMP            PIC 9(4).
       
      *    Multiplicadores para primeiro dígito: 5,4,3,2,9,8,7,6,5,4,3,2
       01  WS-MULT1 VALUE "5432986754 32" PIC X(12).
       
      *    Multiplicadores para segundo: 6,7,8,9,2,3,4,5,6,7,8,9,2
       01  WS-MULT2 VALUE "6789234567 89 2" PIC X(14).
       
       LINKAGE SECTION.
       01  LS-CNPJ            PIC X(14).
       01  LS-RESULTADO       PIC X(10).
       
       PROCEDURE DIVISION USING LS-CNPJ BY REFERENCE LS-RESULTADO.
       
           MOVE LS-CNPJ TO WS-CNPJ.
           
      *    Validar tamanho
           IF FUNCTION LENGTH(FUNCTION TRIM(WS-CNPJ)) NOT = 14
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Validar se contém apenas números
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 14
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               IF WS-CHAR NOT NUMERIC
                   MOVE "INVALIDO" TO LS-RESULTADO
                   GOBACK
               END-IF
           END-PERFORM.
           
      *    ===== PRIMEIRO DÍGITO VERIFICADOR =====
      *    Multiplicadores: 5,4,3,2,9,8,7,6,5,4,3,2 para posições 1-12
           MOVE 0 TO WS-SOMA.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               EVALUATE WS-POS
                   WHEN 1
                       ADD WS-NUM * 5 TO WS-SOMA
                   WHEN 2
                       ADD WS-NUM * 4 TO WS-SOMA
                   WHEN 3
                       ADD WS-NUM * 3 TO WS-SOMA
                   WHEN 4
                       ADD WS-NUM * 2 TO WS-SOMA
                   WHEN 5
                       ADD WS-NUM * 9 TO WS-SOMA
                   WHEN 6
                       ADD WS-NUM * 8 TO WS-SOMA
                   WHEN 7
                       ADD WS-NUM * 7 TO WS-SOMA
                   WHEN 8
                       ADD WS-NUM * 6 TO WS-SOMA
                   WHEN 9
                       ADD WS-NUM * 5 TO WS-SOMA
                   WHEN 10
                       ADD WS-NUM * 4 TO WS-SOMA
                   WHEN 11
                       ADD WS-NUM * 3 TO WS-SOMA
                   WHEN 12
                       ADD WS-NUM * 2 TO WS-SOMA
               END-EVALUATE
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO < 2
               MOVE 0 TO WS-DV1
           ELSE
               COMPUTE WS-DV1 = 11 - WS-RESTO
           END-IF.
           
      *    Verificar primeiro dígito verificador
           IF WS-CNPJ(13:1) NOT = WS-DV1
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    ===== SEGUNDO DÍGITO VERIFICADOR =====
      *    Multiplicadores: 6,7,8,9,2,3,4,5,6,7,8,9,2 para posições 1-13
           MOVE 0 TO WS-SOMA.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               EVALUATE WS-POS
                   WHEN 1
                       ADD WS-NUM * 6 TO WS-SOMA
                   WHEN 2
                       ADD WS-NUM * 7 TO WS-SOMA
                   WHEN 3
                       ADD WS-NUM * 8 TO WS-SOMA
                   WHEN 4
                       ADD WS-NUM * 9 TO WS-SOMA
                   WHEN 5
                       ADD WS-NUM * 2 TO WS-SOMA
                   WHEN 6
                       ADD WS-NUM * 3 TO WS-SOMA
                   WHEN 7
                       ADD WS-NUM * 4 TO WS-SOMA
                   WHEN 8
                       ADD WS-NUM * 5 TO WS
