# Contact Module Guide

## Module structure and ownership

- Keep `ContactModule`, `ContactDomain`, `ContactApplication`,
  `ContactInfrastructure`, `ContactAdminAPI`, `ContactAppAPI`,
  `ContactBackend`, `ContactWebShared`, `ContactWebApp`, and
  `ContactWebAdmin` in their existing separate targets.
- Keep `Form`, `FormField`, `Submission`, and `SubmissionMail` under their own
  namespaces. Models and repository contracts belong in Domain; operation
  inputs/outputs/actions/scopes/use-cases belong in Application; tables,
  migrations, and DBAL adapters belong in Infrastructure.
- Contact owns Admin form-management/submission APIs and the App form
  submission API. Keep public form submission and admin management contracts
  separate; do not make the Backend target depend on a web-composition target.
- Keep operation-specific namespace declarations in the target that owns the
  behavior. Do not add `Add`, `Edit`, `List`, or filter namespace shells to
  `ContactModule` merely for WebAdmin organization.

## Application and persistence

- Where both `List` and `Search` are provided, keep them as separate
  use-cases/query contracts. `List` supplies lightweight form/field selectors;
  `Search` supplies structured paginated WebAdmin tables. Keep their
  input/output schemas independent and do not add either endpoint without a
  corresponding product use-case.
- Keep submission, form-field assignment, and mail delivery orchestration in
  the use-case that owns the behavior. Use operation-specific scope/query
  contracts rather than combined entity-wide query interfaces.
- Use FeatherDBAL table/row abstractions and schema migrations for ordinary
  CRUD, associations, constraints, and indexes. Keep custom SQL only for
  unsupported behavior in the relevant Infrastructure `Database/AccessLayer`.
- Use mock database/DBAL tests for migrations and persistence. Assert schema
  columns, timestamps, defaults, keys, and indexes; test application behavior
  separately from gateway HTTP behavior.

## Backend and web composition

- `ContactBackend` owns Admin/App gateways and use-case construction. Keep
  request/response mappings in the gateway operation file; do not add
  standalone mapping/helper files.
- Keep public form routes and request-facing App clients in `ContactWebApp`;
  admin forms, submissions, routes, events, and clients belong in
  `ContactWebAdmin`; only surface-neutral helpers belong in `ContactWebShared`.
- WebAdmin route features follow the entity/operation structure with
  `Controller`, `Interactor`, `Presenter`, `Repository`, and `Router` as
  applicable. Each feature router constructs its collaborators and registers
  routes using `WebRoute` values from the entity router.
- Keep WebApp/WebAdmin adapters named `Repository`, including generated API
  adapters. Their method names and endpoint calls reflect whether the feature
  uses a simple List endpoint or the structured Query endpoint.

## API generation and validation

- Modify handwritten Admin/App generator sources and regenerate API YAML and
  Swift outputs through the module's checked-in workflow. Do not hand-edit
  generated API files. Keep entity PathCollections merged at the API level,
  use explicit operation IDs, and preserve public component identifiers.
- Do not mirror every import as a direct package dependency; add products only
  when required by SwiftPM/compiler diagnostics and remove unused dependencies.
- The repository-level `AGENTS.md` prohibits running builds, tests, and other
  validations in agent workflows. Record verification needed in the handoff;
  do not execute it here.
