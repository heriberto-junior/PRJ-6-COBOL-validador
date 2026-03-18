       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDAR-CNPJ.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CNPJ            PIC X(14).
       01  WS-MULTIPLICADOR   PIC 9(2).
       01  WS-SOMA            PIC 9(4) VALUE 0.
       01  WS-RESTO           PIC 9(2) VALUE 0.
       01  WS-DIGITO          PIC 9(2).
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
           
      *    Validar se tem 14 dígitos
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
           
      *    Calcular primeiro dígito verificador
           MOVE 0 TO WS-SOMA.
           MOVE 5 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 8
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               COMPUTE WS-TEMP = FUNCTION MOD(WS-TEMP, 11)
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           PERFORM VARYING WS-POS FROM 9 BY 1
               UNTIL WS-POS > 12
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               COMPUTE WS-TEMP = FUNCTION MOD(WS-TEMP, 11)
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO < 2
               MOVE 0 TO WS-DV1
           ELSE
               COMPUTE WS-DV1 = 11 - WS-RESTO
           END-IF.
           
      *    Verificar primeiro dígito
           IF WS-CNPJ(13:1) NOT = WS-DV1
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Calcular segundo dígito verificador
           MOVE 0 TO WS-SOMA.
           MOVE 6 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 9
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               COMPUTE WS-TEMP = FUNCTION MOD(WS-TEMP, 11)
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           PERFORM VARYING WS-POS FROM 10 BY 1
               UNTIL WS-POS > 13
               MOVE WS-CNPJ(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               COMPUTE WS-TEMP = FUNCTION MOD(WS-TEMP, 11)
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO < 2
               MOVE 0 TO WS-DV2
           ELSE
               COMPUTE WS-DV2 = 11 - WS-RESTO
           END-IF.
           
      *    Verificar segundo dígito
           IF WS-CNPJ(14:1) NOT = WS-DV2
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
           GOBACK.
