# ERP Nexus API

API REST backend desenvolvida com **Delphi, Horse, FireDAC e Firebird**, aplicando separação de responsabilidades, Repository Pattern, persistência desacoplada e tratamento centralizado de exceções.

> 🚧 Projeto de portfólio em desenvolvimento.

## 🎯 Objetivo

O ERP Nexus API tem como objetivo explorar uma arquitetura backend moderna aplicada ao ecossistema Delphi.

A proposta é demonstrar como sistemas ERP desenvolvidos em Delphi podem disponibilizar serviços através de APIs REST para integração com aplicações web, mobile e outros sistemas.

## 🛠 Tecnologias

- Delphi 10.4
- Horse
- FireDAC
- Firebird
- Boss
- REST / JSON
- Git / GitHub

## 🏗 Arquitetura

O projeto separa as responsabilidades entre diferentes camadas:

HTTP Request
↓
Middleware
↓
Routes
↓
Controllers
↓
DTOs
↓
Services
↓
Repository Interfaces
↓
FireDAC Repositories
↓
Firebird

### Responsabilidades

**Routes**
Definem os endpoints HTTP disponibilizados pela API.

**Controllers**
Recebem as requisições HTTP e coordenam a comunicação com a camada de aplicação.

**DTOs**
Transportam os dados de entrada e saída da API.

**Services**
Concentram regras e validações da aplicação.

**Repositories**
Abstraem o acesso aos dados através de interfaces.

**Infrastructure**
Implementa detalhes técnicos como FireDAC, conexão e persistência no Firebird.

**Middlewares**
Tratam comportamentos transversais, como exceções e respostas HTTP de erro.

## ✅ Funcionalidades implementadas

- API REST utilizando Horse
- Health Check
- Versionamento de endpoints
- Cadastro de clientes
- Listagem de clientes
- Consulta de cliente por ID
- Persistência real com Firebird
- Integração com FireDAC
- Repository Pattern
- DTOs
- Service Layer
- Injeção por interfaces
- Transações
- Validação de duplicidade
- Middleware global de exceções
- Respostas HTTP padronizadas
- Tratamento HTTP 400, 404, 409 e 500
- Configuração do banco através de variáveis de ambiente

## 🌐 Endpoints

| Método | Endpoint | Descrição |
| --- | --- | --- |
| GET | `/` | Informações da API |
| GET | `/health` | Health Check |
| GET | `/api/v1/clientes` | Lista os clientes |
| GET | `/api/v1/clientes/:id` | Consulta um cliente |
| POST | `/api/v1/clientes` | Cadastra um cliente |

## 📦 Exemplo

### Criar cliente

POST `/api/v1/clientes`

Body:

{
  "name": "Empresa Exemplo Ltda",
  "document": "12345678000190",
  "email": "contato@exemplo.com.br",
  "active": true
}

## ⚠️ Tratamento de erros

A API utiliza tratamento centralizado de exceções.

- `400 Bad Request` — validação
- `404 Not Found` — recurso inexistente
- `409 Conflict` — conflito ou duplicidade
- `500 Internal Server Error` — erro inesperado

Detalhes técnicos internos do banco não são expostos ao consumidor da API.

## 🔐 Configuração

As informações sensíveis do banco são fornecidas através de variáveis de ambiente:

ERP_NEXUS_DB
ERP_NEXUS_DB_USER
ERP_NEXUS_DB_PASSWORD

Credenciais e arquivos físicos do banco não são versionados.

## 🗺 Roadmap

- [x] Estrutura inicial com Horse
- [x] Health Check
- [x] Arquitetura em camadas
- [x] Módulo de clientes
- [x] FireDAC + Firebird
- [x] Repository Pattern
- [x] Persistência
- [x] Transações
- [x] Middleware global de exceções

Próximas etapas:

- [ ] PUT para atualização
- [ ] DELETE / inativação
- [ ] Validação de CPF/CNPJ
- [ ] Validação de e-mail
- [ ] Swagger / OpenAPI
- [ ] Testes automatizados
- [ ] Autenticação e autorização
- [ ] Logging estruturado
- [ ] Novos módulos ERP

## 📚 Status

Projeto em desenvolvimento contínuo como parte do aprofundamento em APIs REST, arquitetura backend e modernização de aplicações Delphi.