# FATHOMS — Feather Architecture for Highly Organized Modular System

This document explains how a FATHOMS-based app is organized from an architectural point of view.

Goal: help new developers understand the system quickly, without needing to read the whole codebase first.

## What You’ll Accomplish

By the end of this guide, you will:

- Understand how the sample project is split into projects, modules, and layers.
- Understand how Onion and Hexagonal architecture are used together.
- Know where to add changes when you implement a new backend feature.

## Key Points

- The backend is a modular monolith.
- Dependencies always point inward: Infrastructure -> Application -> Domain.
- The `app-kernel` package provides shared contracts for all modules.
- Each feature module owns its business logic and persistence adapters.

---

## 1) Big Picture First

Our sample project is a **multi-project workspace** centered around a shared **Application Programming Interface (API)** contract.

- `openapi-generator`: Swift tool for generating OpenAPI specs
- `openapi`: the **central contract** (OpenAPI spec + generated Swift types)
- `backend`: implements the server API defined by OpenAPI (main runtime)
- `web-app`: consumes the API via generated client types

```text
            ┌──────────────────────────────────┐
            │            openapi               │
            │ (API contract + generated types) │
            └───────────────┬──────────────────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            v               v               v
┌──────────────────┐ ┌───────────────┐ ┌───────────────┐
│     backend      │ │    web-app    │ │  native-app   │
│ (implements API) │ │ (API client)  │ │ (API client)  │
└──────────────────┘ └───────────────┘ └───────────────┘
```

---

## 2) Core Concepts (Simple Version)

### What is a Modular Monolith?

A **modular monolith** is one deployable backend application, split into internal feature modules.

- It is **one process** and **one codebase**, using a **shared database**
- Each module **owns its tables** and is responsible for its schema and data access
- Modules should not access each other’s tables directly; instead use module interfaces. If a module explicitly depends on another, it may access that module’s tables in a controlled manner
- The system may use **database schemas/namespaces** in the future to group tables per module
- This gives simpler deployment than microservices, with better structure than a "big ball of code"

In this project:

- One backend runtime (`Server` executable)
- Internal modules such as `system`, `user`, `auth`
- Shared `kernel` package for cross-cutting contracts

### What is Onion Architecture?

Onion architecture organizes code into layers, from core rules to outer technical details.

Dependency rule:

- Outer layers can depend on inner layers
- Inner layers should not depend on outer layers

Dependency direction:
Infrastructure → Application → Domain

The most important rule in this architecture is simple: dependencies always point inward.


```text
┌──────────────────────────────────────────────┐
│                Infrastructure                │
│         (DB, frameworks, HTTP, etc.)         │
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │           Application Layer            │  │
│  │       (use cases, orchestration)       │  │
│  │                                        │  │
│  │  ┌──────────────────────────────────┐  │  │
│  │  │          Domain Layer            │  │  │
│  │  │ (business rules, models, core)   │  │  │
│  │  └──────────────────────────────────┘  │  │
│  │                                        │  │
│  └────────────────────────────────────────┘  │
│                                              │
└──────────────────────────────────────────────┘
```

### What is Hexagonal Architecture (Ports & Adapters)?

Hexagonal architecture says business logic should be in the center, and everything external should connect through adapters.

- **Ports** = interfaces/protocols (what the core needs)
- **Adapters** = implementations (DB adapter, HTTP adapter, etc.)

In this project:

- Domain/Application define protocols
- Infrastructure and Server implement/connect them
- HTTP/OpenAPI controllers are outer adapters

### Similarities & differences

Both Onion and Hexagonal architectures isolate business logic at the core.
Both patterns also ensure external concerns depend inward through abstractions.

Onion emphasizes layered structure and dependency direction.
Hexagonal emphasizes boundaries through ports (interfaces) and adapters (implementations).

In practice, these patterns work together.
In this project, think: Onion for structure, Hexagonal for boundaries.



---

## 3) How This Looks in Backend

Main backend runtime lives in `backend`.

It provides 3 executables:

- `Server`: HTTP API runtime
- `Migrator`: database schema + seed runner
- `Worker`: background jobs/scheduling

Runtime view:

```text

┌─────────────────────┐   ┌─────────────────────┐   ┌──────────────────────┐   ┌────────────────────┐
│      Frontend       │   │      Backend        │   │     Application      │   │      Services      │
│                     │   │                     │   │                      │   │                    │
│ Web / iOS / Android │   │  ┌───────────────┐  │   │   ┌──────────────┐   │   │  ┌──────────────┐  │
│     API Clients     │   │  │   Migrator    │──┼──►│   │    Domain    │   │   │  │  PostgreSQL  │  │
│                     │   │  │ (migrations)  │  │   │   └──────┬───────┘   │   │  │   database   │  │
│                     │   │  └───────────────┘  │   │          │           │   │  └──────────────┘  │
│                     │   │                     │   │   ┌───────▼───────┐  │   │  ┌──────────────┐  │
│                     │   │  ┌───────────────┐  │   │   │  Application  │  │   │  │      S3      │  │
│        HTTP ────────│───┼─►│    Server     │──┼──►│   │  (use cases)  │  │   │  │    storage   │  │
│                     │   │  │ (API Gateway) │  │   │   └──────┬────────┘  │   │  └──────────────┘  │
│                     │   │  └───────┬───────┘  │   │          │           │   │  ┌──────────────┐  │
│                     │   │          │          │   │  ┌───────▼────────┐  │   │  │     SNS      │  │
│                     │   │  ┌───────▼───────┐  │   │  │ Infrastructure │──┼──►│  │     mail     │  │
│                     │   │  │    Worker     │──┼──►│  │   (adapters)   │  │   │  │    sender    │  │
│                     │   │  │ (jobs/sched)  │  │   │  └────────────────┘  │   │  └──────────────┘  │
│                     │   │  └───────────────┘  │   │                      │   │                    │
└─────────────────────┘   └─────────────────────┘   └──────────────────────┘   └────────────────────┘

Connections:
- Clients → Server (HTTP)
- Migrator / Server / Worker → Application layers
- Application Infrastructure → External Services
```

---

## 4) Backend Module Layout (Modular Monolith)

Inside `backend/app-modules`:

- `app-kernel` (shared foundation)
- `app-system-module` (system variables, permissions)
- `app-user-module` (accounts, roles, invitations)
- `app-auth-module` (sessions, magic links, auth flows)

Module map:
```text
                      ┌──────────────────┐
                      │   app-kernel     │
                      │ shared contracts │
                      └───┬────────┬─────┘
                          ▲        ▲
                          │        │
      ┌───────────────────┘        └────────────┐
      │                                         │
┌─────┴─────────────┐                  ┌────────┴────────┐
│ app-system-module │                  │ app-user-module │
└─────┬─────────────┘                  └────────┬────────┘
      ▲                                         ▲
      │                                         │
      └───────────────────┬─────────────────────┘
                          │
                 ┌────────▼────────┐
                 │ app-auth-module │
                 └─────────────────┘
```

Important point: this is one backend app, but split into internal feature modules with explicit dependencies.

---

## 5) Onion Layers in This Project

Each module follows a Domain / Application / Infrastructure split.

For a beginner: the **Domain layer** is the core business rules, which means rules about what is allowed in the product. Examples: an account email cannot be too short, a password must meet minimum length, a role can only contain valid permissions, and a session can expire after a set time.  
The **Application layer** is the step-by-step workflow that applies those rules, for example: receive “create account” input, validate it, hash the password, save it, and return a safe response. In this guide, the **Business layer** means Domain + Application together, while Infrastructure handles technical details like databases and HTTP.

### 5.1 Domain layer (business meaning)

What lives here:

- Business models and their rules
- Domain errors
- Repository interfaces (protocols)

Examples:

- `SystemDomain/Models/Variable.swift`
- `UserDomain/Models/Account.swift`
- `AuthDomain/Models/Session.swift`

What it should avoid:

- HTTP details
- SQL details
- framework-specific I/O

### 5.2 Application layer (use cases)

What lives here:

- Use case definitions (`AddVariable`, `GetMyAccount`, `ListMagicLinks`, ...)
- Input/Output **Data Transfer Objects (DTOs)**
- Read only query interfaces 
- Scopes (grouped capabilities needed by a use case)
- Authorization checks in use case flows

Examples:

- `SystemApplication/UseCases/Variable/AddVariable.swift`
- `UserApplication/UseCases/Account/GetMyAccount.swift`
- `AuthApplication/UseCases/MagicLink/ListMagicLinks.swift`
- `.../Scopes/*.swift`

### 5.3 Infrastructure layer (technical implementation)

What lives here:

- Database Abstraction Layer (migrations, table helpers)
- Repository and query implementations

Examples:

- `SystemInfrastructure/Repositories/DatabaseVariableRepository.swift`
- `UserInfrastructure/Queries/DatabaseAccountQueries.swift`
- `AuthInfrastructure/Database/Migrations/*`

---

## 6) Core Building Blocks Used Across Modules

This project uses a few recurring concepts in many modules.

### Domain model

A domain model is a business object with its own validation and state rules.

- Example: `Variable.create(...)` validates name/value/notes before creation
- Example: `Account.update(...)` validates email and status transitions

### Use case

A use case is one business action.

- Example: `AddVariable`
- Example: `GetMyAccount`
- Example: `ListMagicLinks`

Use cases coordinate rules and data access, but should not contain transport/framework code.

### Data Transfer Object (DTO)

A **Data Transfer Object (DTO)** is a data shape used between layers.

Use-cases accept input DTOs and return output DTOs.
This helps prevent domain internals from leaking into API responses.

### Scope

A scope is a typed bundle of dependencies a use case needs.

- `ReadVariable` exposes read-side variable queries
- `WriteVariable` exposes write-side variable repository
- `WriteAuth` combines account/session/magic-link repositories

This keeps use case dependencies explicit and testable.

### QueryExecutor / TransactionExecutor

These abstractions run use case logic with the right database behavior:

- `QueryExecutor` for read operations
- `TransactionExecutor` for write operations in a transaction

### Authorizer / PermissionAction

Authorization is represented by typed actions and permission keys.

- Use case asks `authorizer.can(subject, perform: action)`
- Action maps to a permission key

---

## 7) Request Flow (From HTTP to Domain)

Typical flow in the backend:

```text
HTTP request
   |
   v
OpenAPI-generated handler protocol (AppAPI/AdminAPI)
   |
   v
Controller method (Server layer)
   |
   v
Module builder creates use case with concrete executors/scope
   |
   v
Application use case executes business flow
   |
   v
Domain model rules + repository/query ports
   |
   v
Infrastructure repository/query adapters
   |
   v
Database
```

Concrete example path:

1. `Server` receives request on `AppAPI` or `AdminAPI`
2. Handler calls `modules.<feature>.make<UseCase>()`
3. Use case runs with `DatabaseQueryExecutor` or `DatabaseTransactionExecutor`
4. Scope exposes the exact repository/query interfaces needed
5. Infrastructure implementation talks to PostgreSQL

This sequence is useful as a debugging checklist.
If one step fails, inspect that layer first before moving outward.

---

## 8) Composition and Wiring

The backend composition happens in `Sources/Server`:

- `Server+Build.swift`: creates a database client and shared infrastructure
- `AppInfrastructure`: shared runtime dependencies (`database`, `idGenerator`)
- `AppModules`: creates module builders (`system`, `user`, `auth`)
- `Routes+Build.swift`: registers App and Admin APIs

This is the "outside" layer doing dependency injection.

```text
buildServer
  -> AppInfrastructure(database, idGenerator)
  -> AppModules(infrastructure)
      -> SystemModule
      -> UserModule
      -> AuthModule
  -> buildRouter(modules)
```

---

## 9) Kernel vs Feature Modules

### Kernel (`app-kernel`)

Kernel is the shared foundation used by all modules.

It defines small common contracts such as:

- Domain: `Model`, `Repository`, `DomainError`
- Application: `UseCase`, `Scope`, `Data Transfer Object (DTO)`, executors, authorization interfaces
- Infrastructure: database executor/migration utilities and shared helpers

Think of kernel as the "common language" and base abstractions.

### Feature modules (`app-*-module`)

Each feature module owns a business area:

- `system`: permissions + variables
- `user`: accounts + roles + invitations
- `auth`: sessions + magic links + sign-in flows

A module typically contains:

- `*Domain` (rules)
- `*Application` (use cases)
- `*Infrastructure` (adapters)

This modular split supports onboarding and future growth without moving to microservices too early.

---


## 10) Mental Model to Keep While Working

If you are implementing a new feature, think in this order:

1. Domain: what business rules and model changes are needed?
2. Application: what use case(s) should expose that behavior?
3. Infrastructure: what repository/query implementation persists it?
4. Server adapter: which API endpoint maps to the use case?

If you keep this order, your changes stay aligned with the existing architecture.


If you are unsure where to start, begin with one small use-case and follow the full flow end-to-end.
