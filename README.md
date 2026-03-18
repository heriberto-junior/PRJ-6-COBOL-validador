# Validador de Documentos Brasileiros

Um validador de documentos brasileiros (CPF e CNPJ) desenvolvido em COBOL com CI/CD integrado ao GitHub Actions.

## Descrição

Este projeto implementa validadores para documentos brasileiros usando GnuCOBOL, com suporte a integração contínua através do GitHub Actions. O programa é compilado automaticamente e executa validações conforme os padrões brasileiros atualizados.

## Documentos Suportados

### CPF (Cadastro de Pessoas Físicas)
- Validação com 11 dígitos
- Cálculo de dois dígitos verificadores
- Rejeita CPFs com todos os dígitos iguais

### CNPJ (Cadastro Nacional da Pessoa Jurídica)
- Validação com 14 dígitos
- Cálculo de dois dígitos verificadores
- Multiplicadores específicos para SP, MG e demais estados

## Estrutura do Projeto

```
validador-documentos/
├── src/
│   ├── validador.cob              # Programa principal
│   └── modulos/
│       ├── validar-cpf.cob        # Módulo de validação CPF
│       └── validar-cnpj.cob       # Módulo de validação CNPJ
├── .github/
│   └── workflows/
│       └── validar-documento.yml  # Pipeline CI/CD
└── README.md
```

## Como Usar via GitHub Actions

1. Acesse a aba **Actions** do repositório
2. Selecione **Validador de Documentos**
3. Clique em **Run workflow**
4. Escolha o tipo de documento (CPF ou CNPJ)
5. Digite o número do documento (sem caracteres especiais)
6. Clique em **Run**
7. Acompanhe a execução nos logs

## Pipeline CI/CD

O arquivo `.github/workflows/validar-documento.yml` configura:

1. Checkout do código
2. Instalação do GnuCOBOL
3. Compilação do programa
4. Execução da validação com entrada do usuário
5. Relatório de sucesso ou falha

## Requisitos

- GnuCOBOL 2.0 ou superior
- Ubuntu/Linux (para GitHub Actions)

## Futuras Melhorias

- Adicionar validação de IE (Inscrição Estadual) com suporte para múltiplos estados
- Integração com API REST via wrapper Python
- Deploy em Google Cloud com Cloud Run
- Suporte para mais tipos de documentos brasileiros
