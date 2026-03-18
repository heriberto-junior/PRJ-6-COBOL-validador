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
       01  WS-ESTADO           PIC X(2).
       
       LINKAGE SECTION.
       01  LS-IE               PIC X(15).
       01  LS-RESULTADO        PIC X(10).
       
       PROCEDURE DIVISION USING LS-IE RETURNING LS-RESULTADO.
       
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
           
      *    Extrair estado (primeiros 2 dígitos)
      *    Formato: EEDDDDDDDDDD ou similar
      *    Validar somente dígitos (próximo passo seria
      *    validar por algoritmo específico do estado)
           
      *    Para simplicidade, aceitar qualquer IE bem formado
      *    Futuramente, adicionar validações específicas por estado
           
      *    Validação básica: não pode ser todos zeros
           IF WS-IE = "0000000000000000"
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Validação por tamanho (alguns estados)
      *    São Paulo: 14 dígitos
      *    Minas Gerais: 13 dígitos
      *    Rio de Janeiro: 8 dígitos
      *    Bahia: 8 ou 9 dígitos
           
           EVALUATE WS-TAMANHO
               WHEN 8
      *            RJ ou BA (formato curto)
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 9
      *            BA (formato longo)
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 10
      *            Outros formatos
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN 13
      *            MG (Minas Gerais)
                   PERFORM VALIDAR-MG
               WHEN 14
      *            SP (São Paulo)
                   PERFORM VALIDAR-SP
               WHEN 15
      *            Outros formatos
                   MOVE "VALIDO" TO LS-RESULTADO
               WHEN OTHER
                   MOVE "INVALIDO" TO LS-RESULTADO
           END-EVALUATE.
           
           GOBACK.
       
       VALIDAR-SP.
      *    Algoritmo específico para São Paulo (14 dígitos)
      *    Primeira sequência: posições 1-8
           MOVE 0 TO WS-SOMA.
           MOVE 5 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 8
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               ADD WS-NUM * WS-MULTIPLICADOR TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           DIVIDE WS-SOMA BY 11 GIVING WS-DIGITO 
               REMAINDER WS-RESTO.
           IF WS-RESTO = 0
               MOVE 0 TO WS-DV
           ELSE IF WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF
           END-IF.
           
      *    Verificar primeiro dígito verificador (posição 9)
           IF WS-IE(9:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
      *    Segunda sequência: posições 10-14
           MOVE 0 TO WS-SOMA.
           MOVE 9 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 10 BY 1
               UNTIL WS-POS > 14
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               ADD WS-NUM * WS-MULTIPLICADOR TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           DIVIDE WS-SOMA BY 11 GIVING WS-DIGITO 
               REMAINDER WS-RESTO.
           IF WS-RESTO = 0
               MOVE 0 TO WS-DV
           ELSE IF WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF
           END-IF.
           
      *    Verificar segundo dígito verificador (última posição)
           IF WS-IE(14:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
       
       VALIDAR-MG.
      *    Algoritmo específico para Minas Gerais (13 dígitos)
      *    MG usa algoritmo diferente de SP
           MOVE 0 TO WS-SOMA.
           MOVE 11 TO WS-MULTIPLICADOR.
           PERFORM VARYING WS-POS FROM 1 BY 1
               UNTIL WS-POS > 12
               MOVE WS-IE(WS-POS:1) TO WS-CHAR
               MOVE FUNCTION NUMVAL(WS-CHAR) TO WS-NUM
               ADD WS-NUM * WS-MULTIPLICADOR TO WS-SOMA
               SUBTRACT 1 FROM WS-MULTIPLICADOR
           END-PERFORM.
           
           DIVIDE WS-SOMA BY 11 GIVING WS-DIGITO 
               REMAINDER WS-RESTO.
           IF WS-RESTO = 0
               MOVE 0 TO WS-DV
           ELSE IF WS-RESTO = 1
               MOVE 0 TO WS-DV
           ELSE
               COMPUTE WS-DV = 11 - WS-RESTO
           END-IF
           END-IF.
           
           IF WS-IE(13:1) NOT = WS-DV
               MOVE "INVALIDO" TO LS-RESULTADO
               GOBACK
           END-IF.
           
           MOVE "VALIDO" TO LS-RESULTADO.
