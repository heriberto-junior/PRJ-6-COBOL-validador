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
      *    Multiplicadores: 5,4,3,2,9,8,7,6,5,4,3,2
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
                       COMPUTE WS-TEMP = WS-NUM *
