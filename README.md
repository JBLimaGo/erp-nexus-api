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
- Persistência real com Firebird
- Integração com FireDAC
- Repository Pattern
- DTOs
- Service Layer
- Injeção por interfaces
- Middleware global de exceções
- Respostas HTTP padronizadas
- Tratamento HTTP 400, 404, 409 e 500
- Configuração do banco através de variáveis de ambiente

### Clientes

A API possui um CRUD REST completo para gerenciamento de clientes:

- Criação de clientes
- Listagem de clientes
- Consulta por ID
- Atualização de dados
- Inativação lógica (Soft Delete)
- Reativação de clientes
- Validação de documento duplicado
- Tratamento de conflitos
- Persistência com Firebird
- Transações com Commit e Rollback

### Regras de negócio

- O documento do cliente deve ser único.
- A unicidade também considera clientes inativos.
- Clientes não são excluídos fisicamente.
- O endpoint DELETE realiza Soft Delete através do campo `ACTIVE`.
- Operações DELETE são idempotentes.
- Clientes inativos podem ser reativados através de atualização.
- Um cliente não pode assumir o documento pertencente a outro cadastro.

## 🌐 Endpoints

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/health` | Verifica se a API está disponível |

### Clientes

| Método | Endpoint | Descrição | Status principal |
|---|---|---|---|
| GET | `/api/v1/clientes` | Lista clientes | 200 |
| GET | `/api/v1/clientes/:id` | Consulta cliente por ID | 200 |
| POST | `/api/v1/clientes` | Cria um cliente | 201 |
| PUT | `/api/v1/clientes/:id` | Atualiza ou reativa um cliente | 200 |
| DELETE | `/api/v1/clientes/:id` | Inativa um cliente (Soft Delete) | 204 |

## 📦 Exemplo

### Criar cliente

POST `/api/v1/clientes`

```json
{
  "name": "Empresa Exemplo Ltda",
  "document": "12345678000190",
  "email": "contato@exemplo.com.br",
  "active": true
}
```
Resposta: 201 Created

## ✏️ Atualização de cliente

PUT `/api/v1/clientes/1`

```json
{
  "name": "Empresa Alpha Atualizada Ltda",
  "document": "12345678000190",
  "email": "novoemail@empresa.com.br",
  "active": true
}
```

Resposta: 200 OK


## 🗑️ Soft Delete

A exclusão de clientes utiliza inativação lógica.

DELETE `/api/v1/clientes/1`

Resposta: 204 No Content

## 🌐 Status HTTP utilizados

| Status | Significado |
|---|---|
| 200 | Operação realizada com sucesso |
| 201 | Recurso criado |
| 204 | Operação realizada sem conteúdo de resposta |
| 400 | Dados ou parâmetros inválidos |
| 404 | Recurso não encontrado |
| 409 | Conflito de regra de negócio |
| 500 | Erro interno inesperado |


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

## 🗺️ Roadmap

### Concluído

- [x] Estrutura inicial da API com Horse
- [x] Health Check
- [x] Arquitetura em camadas
- [x] FireDAC + Firebird
- [x] Variáveis de ambiente
- [x] Repository Pattern
- [x] Middleware global de exceções
- [x] CRUD REST de Clientes
- [x] Validações de negócio
- [x] Soft Delete
- [x] Reativação de clientes
- [x] Transações com Commit/Rollback

### Próximas evoluções

- [ ] Paginação
- [ ] Filtros e pesquisa
- [ ] Swagger / OpenAPI
- [ ] Testes automatizados
- [ ] Autenticação JWT
- [ ] Logs estruturados
- [ ] Docker
- [ ] CI/CD

## 📚 Status

Projeto em desenvolvimento contínuo como parte do aprofundamento em APIs REST, arquitetura backend e modernização de aplicações Delphi.