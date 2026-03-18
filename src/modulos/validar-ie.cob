       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALIDAR-IE.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-IE               PIC X(15).
       01  WS-TAMANHO          PIC 9(2).
       01  WS-POS              PIC 9(2).
       01  WS-CHAR             PIC X(1).
       01  WS-SOMA             PIC 9(4) VALUE 0.
       01  WS-RESTO            PIC 9(2) VALUE 0.
       01  WS-MULTIPLICADOR    PIC 9(2).
       01  WS-NUM              PIC 9(2).
       01  WS-DIGITO           PIC 9(2).
       01  WS-DV               PIC 9(1).
       01  WS-TEMP             PIC 9(4).
       
       LINKAGE SECTION.
       01  LS-IE               PIC X(15).
       01  LS-RESULTADO        PIC X(10).
       
       PROCEDURE DIVISION USING LS-IE BY REFERENCE LS-RESULTADO.
       
           MOVE LS-IE TO WS-IE.
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-IE)) 
               TO WS-TAMANHO.
           
      *    IE deve ter entre 10 e 15 dígitos
           IF WS-TAMANHO < 10 OR WS-TAMANHO > 15
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Validar se contém apenas números
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > WS-TAMANHO
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               IF WS-CHAR NOT NUMERIC
                   MOVE "INVALIDO" TO LS-RESULTADO
                   GOBACK
               END-IF
           END-PERFORM.
           
      *    Não pode ser todos zeros
           IF WS-IE = "0000000000000000"
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Validação por tamanho específico de estado
           EVALUATE WS-TAMANHO
               WHEN 8
      *            RJ ou BA (formato curto) - válido
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 9
      *            BA (formato longo) - válido
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 10
      *            Outros formatos - válido
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 13
      *            MG (Minas Gerais)
                   PERFORM VALIDAR-MG
               WHEN 14
      *            SP (São Paulo)
                   PERFORM VALIDAR-SP
               WHEN 15
      *            Outros formatos - válido
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN OTHER
                   MOVE "INVALIDO" TO LS-RESULTADO
           END-EVALUATE.
           
           GOBACK.
       
       VALIDAR-SP.
      *    Algoritmo para São Paulo (14 dígitos)
           MOVE 0 TO WS-SOMA.
           MOVE 5 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 8
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO = 0 OR WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF.
           
           IF WS-IE(9:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Segunda sequência
           MOVE 0 TO WS-SOMA.
           MOVE 9 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 10 BY 1
               UNTIL WS-POS > 14
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO = 0 OR WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF.
           
           IF WS-IE(14:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
       
       VALIDAR-MG.
      *    Algoritmo para Minas Gerais (13 dígitos)
           MOVE 0 TO WS-SOMA.
           MOVE 11 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               COMPUTE WS-TEMP = WS-NUM * WS-MULTIPLICADOR
               ADD WS-TEMP TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           COMPUTE WS-RESTO = FUNCTION MOD(WS-SOMA, 11).
           IF WS-RESTO = 0 OR WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF.
           
           IF WS-IE(13:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
