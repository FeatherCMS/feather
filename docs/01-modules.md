# FATHOMS Module Guide

This guide explains how to build one module in the FATHOMS style.

It uses one running example: **User Account**.

## What You Will Accomplish

By the end of this guide, you will:

- Understand what belongs in Domain, Application, and Infrastructure.
- Know how one use-case flows through ports and adapters.
- Be able to add one new module feature using the existing project patterns.

## Key Points

- A module is layered: Domain -> Application -> Infrastructure.
- A shared `app-kernel` provides common contracts used by modules.
- Use-cases run in Application and call abstract ports.
- Infrastructure implements those ports with Structured Query Language (SQL) and mappings.
- Use-cases exchange Data Transfer Objects (DTOs), not raw domain entities.
- Keep terms and naming consistent across files.

---

## 1) Module Shape

A FATHOMS module combines Onion and Hexagonal ideas.

```text
      +----------------------------+
      | Infrastructure             |
      | - database tables          |
      | - repository/query adapters|
      +--------------+-------------+
                     |
                     v
      +--------------+-------------+
      | Application                |
      | - use-cases                |
      | - data transfer objects    |
      | - scopes and policies      |
      +--------------+-------------+
                     |
                     v
      +--------------+-------------+
      | Domain                     |
      | - models and rules         |
      | - repository interfaces    |
      +----------------------------+
```

Dependency direction is always inward.

### 1.1 app-kernel

`app-kernel` is the shared space for common contracts used by modules.
It contains reusable Domain, Application, and Infrastructure contracts.
Keep it thin and lightweight. Add only shared patterns that reduce duplication.
Kernel Application contracts define ports that Infrastructure adapters implement.

---

## 2) Domain Layer

The Domain layer describes business meaning.
It should depend only on `Foundation` and kernel Domain contracts.
It should not depend on HTTP, SQL, or framework runtime details.

### 2.1 Model

A model contains business state and validation rules.

Snippet (from `UserDomain/Models/Account.swift`):

```swift
public struct Account: Model {
    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong
        case passwordTooShort
        case passwordTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let email: String
        public let password: String
        public let passwordHash: String
        public let status: Status
    }

    public static func create(
        id: String,
        email: String,
        password: String,
        passwordHash: String
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        return .init(id: id, email: email, password: password, passwordHash: passwordHash, status: .active)
    }
}
```

What this snippet does:

1. Defines domain-level validation errors.
2. Defines the payload for new entities.
3. Enforces validation inside `create`.

### 2.2 Repository interface

Domain repositories are ports. They define required persistence behavior.

Snippet (from `UserDomain/Repositories/AccountRepository.swift`):

```swift
public protocol AccountRepository: Repository {
    func findBy(id: String) async throws -> Account?
    func findBy(email: String) async throws -> Account?
    func insert(_ model: Account.New) async throws -> Account
    func update(_ model: Account) async throws -> Account
    func delete(id: String) async throws -> Bool
}
```

Naming used in this project:

- Repository lookups use `findBy...`.

### 2.3 Model conventions

Model conventions in this project include:

- `struct` models with explicit validation rules.
- nested `New` and nested domain `Error`.
- controlled initialization (`package init`) in full model files.
- model behavior methods such as `create`, `update`, and `validate`.

These conventions keep domain behavior predictable across modules.

---

## 3) Application Layer

The Application layer runs business operations.
It is responsible for use-cases, access control, query interfaces, and unit-of-work handling.
Application should depend on Domain and kernel Application contracts, not Infrastructure details.

### 3.1 Use-case

A use-case orchestrates dependencies and returns DTOs.
A **Data Transfer Object (DTO)** carries use-case input and output values.

Snippet (from `UserApplication/UseCases/Account/AddAccount.swift`):

```swift
public struct AddAccount: UseCase {
    let transaction: any TransactionExecutor<WriteAccount>
    let idGenerator: any IDGenerator
    let passwordHasher: any PasswordHasher

    public struct Input: DTO {
        public let email: String
        public let password: String
    }

    public func execute(_ input: Input) async throws -> AccountDetail {
        let id = idGenerator.generate()
        let hash = try await hashPassword(using: passwordHasher, original: input.password)

        let model = try await transaction.run { context in
            try await context.account.insert(
                Account.create(id: id, email: input.email, password: input.password, passwordHash: hash)
            )
        }
        return model.asDetail
    }
}
```

What this snippet does:

1. Receives an input DTO.
2. Creates domain input with generated ID and hashed password.
3. Persists via repository inside a transaction.
4. Returns output DTO.

### 3.2 DTOs

A **Data Transfer Object (DTO)** is the shape exchanged at use-case boundaries.

Snippet (from `UserApplication/DTOs/AccountDetail.swift`):

```swift
public struct AccountDetail: DTO {
    public let id: String
    public let email: String
    public let status: AccountStatus
    public let createdAt: Date
    public let updatedAt: Date
}
```

Why DTOs matter:

- Domain entities can contain internal fields such as `passwordHash`.
- Output DTOs can intentionally hide internal fields.

### 3.3 Query interfaces and scopes

Query interfaces are read-side ports.

Snippet (from `UserApplication/Queries/AccountQueries.swift`):

```swift
public protocol AccountQueries: Sendable {
    func list(query: AccountList.Query) async throws -> AccountList
    func count(query: AccountList.Query) async throws -> Int
    func getBy(id: String) async throws -> AccountDetail
}
```

Scopes group dependencies for executors.

Snippet (from `UserApplication/Scopes/WriteAccount.swift`):

```swift
public struct WriteAccount: Scope {
    public let account: any AccountRepository
    public let role: any RoleRepository
}
```

Why scopes matter:

- `QueryExecutor` + read scope for read-only operations.
- `TransactionExecutor` + write scope for state-changing operations.
- Use-cases do not need to know how database connections are created.
- Query interfaces should use DTO input/output shapes for stable read models.

### 3.4 Authorizer, permissions, and actions

Application access control is role and permission based.

Key terms:

- **Subject**: the actor (usually the authenticated account).
- **Role**: a named group of permissions.
- **Permission**: one allowed capability, such as listing or editing resources.
- **Action**: the operation being checked by the authorizer.

The typical flow is:

1. Use-case declares an action.
2. Authorizer resolves the subject’s permissions.
3. Use-case continues only when action is allowed.

In this architecture, `PermissionProvider` defines available permissions, `AuthAction` models checks, and `PermissionAction` maps actions directly to permission keys. Actions can be composed when one check is not enough.

Snippet (pattern used in this codebase):

```swift
public enum AuthPermissions: PermissionProvider {
    static let listMagicLinks = PermissionKey("auth.list.magic_link")
}

struct Action: PermissionAction {
    let key = AuthPermissions.listMagicLinks
}
```

---

## 4) Infrastructure Layer

The Infrastructure layer implements ports.
Repositories primarily handle model persistence operations, while queries provide read-only dataset views.

### 4.1 Database Access Layer

The database access layer includes table and row definitions, row-create payloads, row decoding, and query execution helpers.

Snippet (from `UserInfrastructure/Database/AccessLayer/AccountTable.swift`):

```swift
func find(id: String) async throws -> Row? {
    try await connection.run(
        query: #"""
            SELECT *
            FROM user_account
            WHERE id=\#(id)
            LIMIT 1;
            """#
    ) { sequence in
        guard let row = try await sequence.collect().first else {
            return nil
        }
        return try Row(from: row)
    }
}
```

What this snippet does:

1. Builds a parameterized SQL query.
2. Executes it through the database connection.
3. Maps the first row into a typed table row object.

### 4.2 Query adapter

Snippet (from `UserInfrastructure/Queries/DatabaseAccountQueries.swift`):

```swift
public func getBy(id: String) async throws -> AccountDetail {
    let table = AccountTable(connection: connection)
    guard let row = try await table.find(id: id) else {
        throw RepositoryError.notFound
    }
    return row.asDetail
}
```

This adapter converts table output into an application DTO.

### 4.3 Repository adapter

Snippet (from `UserInfrastructure/Repositories/DatabaseAccountRepository.swift`):

```swift
public func insert(_ model: Account.New) async throws -> Account {
    let table = AccountTable(connection: connection)
    let saved = try await table.save(
        row: .init(
            id: model.id,
            email: model.email,
            password: model.passwordHash,
            status: model.status.rawValue
        )
    )
    return try saved.asDomain
}
```

This adapter converts application/domain input into database rows, then back to domain.

### 4.4 Migration

Snippet (from `UserInfrastructure/Database/Migrations/TableMigration.swift`):

```swift
#"""
CREATE TABLE IF NOT EXISTS user_account (
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
);
"""#
```

This migration defines the base table shape for the User Account feature.

### 4.5 Seed migrations

Seed migrations add baseline data needed by features.
Typical examples are initial roles, permissions, and system values.
Use table migrations for schema, and seed migrations for initial records.

### 4.6 SQL-first approach

This project uses a SQL-first data access style.
The goal is explicit queries, predictable behavior, and easier performance tuning.
The table layer owns row mapping, while query and repository adapters translate between rows, domain models, and DTOs.
This approach avoids hiding critical database behavior behind a heavyweight Object-Relational Mapping (ORM) layer.

---

## 5) End-to-End Flow

For `AddAccount`, the flow is:

1. An Application Programming Interface (API) handler receives the request.
2. Handler calls `AddAccount.execute` with input DTO.
3. Use-case validates and creates domain data.
4. Repository port is called inside a transaction.
5. Infrastructure repository runs SQL and returns domain model.
6. Use-case maps result to output DTO.

```text
HTTP request
   |
   v
API handler
   |
   v
AddAccount use-case
   |
   v
AccountRepository port
   |
   v
Infrastructure repository adapter
   |
   v
SQL query execution
   |
   v
AccountDetail DTO response
```

---

## 6) Naming Conventions In This Project

- Use-cases: `AddX`, `EditX`, `GetX`, `ListX`, `RemoveX`
- Repository lookups: `findBy...`
- Query methods: `get...`, `list...`
- Scopes: `ReadX`, `WriteX`

Keep these names consistent. Consistency reduces onboarding time.

---

## 7) Build Checklist For One New Feature

1. Add domain model rules and errors.
2. Add repository and query interfaces.
3. Add use-case input and output DTOs.
4. Add or extend read/write scopes.
5. Add permissions and actions when access control is required.
6. Implement infrastructure table, query adapter, and repository adapter.
7. Add table and seed migration updates as needed.
8. Wire use-case in module builder and API handler.

If you follow these steps, your feature will fit the existing architecture cleanly.
