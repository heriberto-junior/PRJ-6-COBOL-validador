# [ENG] CPF/CNPJ Validator

A Brazilian document validator (CPF and CNPJ) built in COBOL with CI/CD integrated into GitHub Actions.

## Description

This project implements validators for Brazilian documents using GnuCOBOL, with support for continuous integration through GitHub Actions. The program is automatically compiled and runs validations according to updated Brazilian standards.

## Supported Documents

### CPF (Individual Taxpayer Registry)
- Validation with 11 digits
- Calculation of two check digits
- Rejects CPFs with all identical digits

### CNPJ (National Corporate Taxpayer Registry)
- Validation with 14 digits
- Calculation of two check digits
- Specific multipliers for SP, MG and other states

## Project Structure

```
validador-documentos/
├── src/
│   ├── validador.cob              # Main program
│   └── modulos/
│       ├── validar-cpf.cob        # CPF validation module
│       └── validar-cnpj.cob       # CNPJ validation module
├── .github/
│   └── workflows/
│       └── validar-documento.yml  # CI/CD pipeline
└── README.md
```

## How to Use via GitHub Actions

1. Go to the **Actions** tab of the repository
2. Select **Validador de Documentos**
3. Click **Run workflow**
4. Choose the document type (CPF or CNPJ)
5. Enter the document number
6. Click **Run**
7. Follow the execution in the logs

## CI/CD Pipeline

The `.github/workflows/validar-documento.yml` file configures:

1. Code checkout
2. GnuCOBOL installation
3. Program compilation
4. Validation execution with user input
5. Success or failure report

## Requirements

- GnuCOBOL 2.0 or higher
- Ubuntu/Linux (for GitHub Actions)

## Future Improvements

- REST API integration via Python wrapper
- Deploy on Google Cloud with Cloud Run
- Frontend implementation with CSS/JavaScript/HTML

---
---

# [PT-BR] Validador de CPF/CNPJ

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
5. Digite o número do documento
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

- Integração com API REST via wrapper Python
- Deploy em Google Cloud com Cloud Run
- Implementação de um Front End com CSS/JavaScript/HTML
