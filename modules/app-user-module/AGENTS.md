# User Module Guide

Use this guide as the User module's source of truth for target boundaries,
namespaces, application operations, database adapters, OpenAPI generation,
WebAdmin composition, and tests. Keep its structure consistent with the System
module's current implementation.

## Module structure and ownership

- The module owns identities, roles, and their association. Keep domain models,
  application operations, queries, tables, and persistence adapters nested
  under `Identity`, `Role`, and `IdentityRole` as appropriate.
- The package exposes an Admin API, not an app-facing API. Do not retain an App
  generator, generated App API, or App API client unless User explicitly takes
  ownership of such an API.
- `UserOpenAPIGeneratorSupport` is a narrow exception for User-owned schemas
  shared with other modules' generators. Keep only shared schema declarations
  there; generator implementation and API-specific paths belong to the Admin
  generator target.
- Authorization and permission persistence belongs to its owning module. Do
  not recreate System's permission table or move auth-role-permission storage
  into User. Use the System-owned contracts/tables through declared target
  dependencies where required.

## Application and persistence

- Keep `Identity` and `Role` operations as sibling namespace declarations with
  their own `Action`, `Input`, `Output`, `Scope`, `UseCase`, and query contracts
  as applicable. `List` and `Search` are distinct: list queries return simple
  lookup results, while search queries handle structured criteria, sorting,
  pagination, and totals. Keep their schemas, criteria, and result types
  separate.
- Use the shared DBAL table/query/repository APIs. Put the identity-role join
  schema and row types under `IdentityRole.Table`; keep its columns, migration,
  and row definitions consistent. Do not introduce concrete SQL-driver
  dependencies into User infrastructure or ordinary tests.
- Keep the User aggregate migration and seed migration at the infrastructure
  root. Infrastructure tests use Feather's mock connection/platform and assert
  schema details for each table, including timestamps, defaults, keys, and
  indexes—not only table names or query counts.
- Test application use-cases independently from HTTP composition. Cover
  successful and forbidden execution, field-change/clearing behavior,
  transaction boundaries, event publication, and list/search criteria where
  applicable.

## Admin API and WebAdmin

- The generator owns the User Admin API contract. Keep entity and operation
  namespaces/files aligned with the System generator, with one path item per
  URL (including a combined ID path item) and separate List and Query response
  schemas. Regenerate YAML and Swift output through the checked-in generator;
  never hand-edit generated sources.
- PATCH operations use a required entity-specific update mask and
  PATCH-specific request schema. Preserve omitted-versus-cleared field
  semantics and cover malformed masks, missing selected values, and nullable
  field clearing in composition tests.
- WebAdmin routes live under
  `Sources/Composition/WebAdmin/Routes/<Entity>/<Operation>/`. Extend the
  `Identity.<Operation>` or `Role.<Operation>` namespace with
  `Controller.Interface|Default`, `Interactor.Interface|Default`,
  `Presenter.Interface|Default`, `Repository.Interface|OpenAPI`, and `Router`
  as applicable. Keep the `Router` responsible for construction and
  registration; do not add `Feature`, `Abstraction/`, or `Implementation/`
  wrapper structures.
- Pass `AppEnvironment` through the router tree. Construct the API client at
  the authenticated request boundary from the environment and
  `AuthenticatedRequestContext`; do not pass only a URL through every feature
  or share request credentials globally.
- Use shared `Admin` components and prepared view state. Controllers own HTTP
  decoding, permissions, nonce handling, validation, and error branching;
  interactors coordinate; OpenAPI repositories map all documented responses;
  presenters own user-facing status and redirect behavior.
- Keep list/search/pagination context through navigation and removal. Use
  `AdminListActions`, nonce-protected removal confirmation, and return
  cancellation to the correct origin page.

## Package and validation

- Do not mirror every Swift import with a direct package dependency. Rely on
  transitive module availability when SwiftPM/the compiler permits it; add a
  direct product dependency only when required to build. Remove unused direct
  dependencies after moves, and use `public import` only for deliberate
  re-exports.
- Test targets use shared database/DBAL mocks, not a PostgreSQL or other
  concrete driver. Composition tests exercise the generated API router and
  gateway with the mock database and authorizer; assert the HTTP contract and
  consume mock responses.
- Repository-level `AGENTS.md` forbids running tests or validations in agent
  workflows. Record formatting, package, generator, and downstream-consumer
  checks in the handoff notes when relevant, but do not execute them here.
