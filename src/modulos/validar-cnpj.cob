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
       
       LINKAGE SECTION.
       01  LS-CNPJ            PIC X(14).
       01  LS-RESULTADO       PIC X(10).
       
       PROCEDURE DIVISION USING LS-CNPJ BY REFERENCE LS-RESULTADO.
       
           MOVE LS-CNPJ TO WS-CNPJ.
           
           IF FUNCTION LENGTH(FUNCTION TRIM(WS-CNPJ)) NOT = 14
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 14
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               IF WS-CHAR NOT NUMERIC
                   MOVE "INVALIDO" TO LS-RESULTADO
                   GOBACK
               END-IF
           END-PERFORM.
           
           MOVE 0 TO WS-SOMA.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               EVALUATE WS-POS
                   WHEN 1
                       COMPUTE WS-TEMP = WS-NUM * 5
                   WHEN 2
                       COMPUTE WS-TEMP = WS-NUM * 4
                   WHEN 3
                       COMPUTE WS-TEMP = WS-NUM * 3
                   WHEN 4
                       COMPUTE WS-TEMP = WS-NUM * 2
                   WHEN 5
                       COMPUTE WS-TEMP = WS-NUM * 9
                   WHEN 6
                       COMPUTE WS-TEMP = WS-NUM * 8
                   WHEN 7
                       COMPUTE WS-TEMP = WS-NUM * 7
                   WHEN 8
                       COMPUTE WS-TEMP = WS-NUM * 6
                   WHEN 9
                       COMPUTE WS-TEMP = WS-NUM * 5
                   WHEN 10
                       COMPUTE WS-TEMP = WS-NUM * 4
                   WHEN 11
                       COMPUTE WS-TEMP = WS-NUM * 3
                   WHEN 12
                       COMPUTE WS-TEMP = WS-NUM * 2
               END-EVALUATE
               ADD WS-TEMP TO WS-SOMA
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO < 2
               MOVE 0 TO WS-DV1
           ELSE
               COMPUTE WS-DV1 = 11 - WS-RESTO
           END-IF.
           
           IF WS-CNPJ(13:1) NOT = WS-DV1
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE 0 TO WS-SOMA.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               EVALUATE WS-POS
                   WHEN 1
                       COMPUTE WS-TEMP = WS-NUM * 6
                   WHEN 2
                       COMPUTE WS-TEMP = WS-NUM * 7
                   WHEN 3
                       COMPUTE WS-TEMP = WS-NUM * 8
                   WHEN 4
                       COMPUTE WS-TEMP = WS-NUM * 9
                   WHEN 5
                       COMPUTE WS-TEMP = WS-NUM * 2
                   WHEN 6
                       COMPUTE WS-TEMP = WS-NUM * 3
                   WHEN 7
                       COMPUTE WS-TEMP = WS-NUM * 4
                   WHEN 8
                       COMPUTE WS-TEMP = WS-NUM * 5
                   WHEN 9
                       COMPUTE WS-TEMP = WS-NUM * 6
                   WHEN 10
                       COMPUTE WS-TEMP = WS-NUM * 7
                   WHEN 11
                       COMPUTE WS-TEMP = WS-NUM * 8
                   WHEN 12
                       COMPUTE WS-TEMP = WS-NUM * 9
               END-EVALUATE
               ADD WS-TEMP TO WS-SOMA
           END-PERFORM.
           
           COMPUTE WS-TEMP = WS-DV1 * 2.
           ADD WS-TEMP TO WS-SOMA.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO < 2
               MOVE 0 TO WS-DV2
           ELSE
               COMPUTE WS-DV2 = 11 - WS-RESTO
           END-IF.
           
           IF WS-CNPJ(14:1) NOT = WS-DV2
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
           GOBACK.
