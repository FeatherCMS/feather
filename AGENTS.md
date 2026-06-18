# AGENTS.md - Workspace rules

Purpose: define the repo-wide implementation rules for AI agents working in this workspace.

Scope: these rules apply to the whole repository unless a deeper `AGENTS.md` file says otherwise.

Docs are the design source of truth. Follow the patterns in `docs/00-index.md`, `docs/01-modules.md`, and `docs/02-server.md` when deciding structure, naming, and layer boundaries.

## 1) Current project structure

This workspace is a multi-project Swift repository centered on a shared OpenAPI contract:

- `openapi`
  - Shared OpenAPI libraries used by clients and servers.
  - Contains the generated app and management API types.
- `backend`
  - Modular backend runtime.
  - Executables: `Server`, `Migrator`, `Worker`.
  - Internal modules live under `app-modules/`.
- `web-app`
  - Hummingbird-based web app.
  - Feature code lives under the web app feature source root in feature-scoped folders.
  - Shared code lives under `Bootstrap`, `Core`, `Platform`, `Shared`, and `Views`.
- `native-app`
  - Native client that consumes the shared OpenAPI contract.
- `docs`
  - Architecture and module notes.

Treat the code layout as the concrete structure and the docs as the pattern guide.

## 2) Design patterns to follow

### 2.1 Backend module pattern

Use the FATHOMS style described in the docs:

- `Domain`
  - Models, rules, `DomainError`, and repository/query ports.
- `Application`
  - `UseCase` implementations, DTOs, scopes, permissions/actions, and orchestration.
- `Infrastructure`
  - SQL-first table access, repository/query adapters, migration code, and technical helpers.
- `Server`
  - HTTP/OpenAPI assembly, routes, middleware, adapters, and request/response mapping.
- `Migrator`
  - Schema changes and seed data.
- `Worker`
  - Background jobs built from the same application ports and scopes.

Dependency direction must stay inward:

`Server` / `Migrator` / `Worker` -> `Infrastructure` -> `Application` -> `Domain`

### 2.2 Composition pattern

- Prefer module builders and a shared runtime dependency bag, as shown in `docs/02-server.md`.
- Keep wiring code in composition layers, not in use-case or domain code.
- Build use-cases from executors, scopes, and adapters.
- Keep per-feature wiring isolated and small.

### 2.3 API and mapping pattern

- Keep OpenAPI types in the shared OpenAPI package.
- Use generated request/response types at the HTTP boundary.
- Keep schema/DTO conversion in dedicated adapter or helper files.
- Keep handlers thin: parse input, call use-case, map output.

### 2.4 Web app feature pattern

- Keep each feature self-contained under the web app feature source root.
- Prefer the existing local structure in that feature:
  - `Domain`
  - `Application`
  - `Infrastructure`
  - `Presentation`
  - `Presentation/Views`
- Keep reusable cross-feature code in `Core`, `Platform`, `Shared`, or `Views` only when it is genuinely shared.

## 3) Core implementation rules

### 3.1 One object per file

- Always keep one primary object per file.
- "Object" means one `struct`, `class`, `enum`, `protocol`, or one tightly scoped `extension` family.
- If a file starts accumulating a second unrelated type, split it into a new file.
- Keep related helper types in separate files unless they are tightly coupled and genuinely small.
- Generated code can be exempt if the generator requires a different layout, but hand-written code should follow this rule.

### 3.2 File naming

- Use feature-oriented file names that describe the primary object.
- Prefer names that match the contained type or extension:
  - `AdminListUserRolePresenter.swift`
  - `UserInvitationForm.swift`
  - `ObjectToSchema+<Feature>.swift`
- Avoid vague names like `Helpers.swift` unless the file is truly shared and narrowly scoped.

### 3.3 Layer boundaries

- Do not leak transport-specific types into domain code.
- Do not put HTTP, SQL, or framework-specific behavior into `Domain`.
- Keep controllers, use-cases, repositories, queries, adapters, and mappings in their appropriate layer.
- Use repository/query ports in `Domain` or `Application`, with implementations in `Infrastructure`.

### 3.4 Mapping and adapter code

- Keep request/response mapping close to adapter layers.
- Avoid manual field-by-field mapping in handlers when a dedicated mapping helper is the existing pattern.
- Prefer small adapter files over large mixed-purpose files.

### 3.5 OpenAPI generation rule

- Never edit OpenAPI YAML files directly.
- Treat `openapi/*.yaml` files as generated artifacts.
- Always make OpenAPI contract changes in the Swift OpenAPI generator project under `openapi-generator`.
- After changing generator sources, regenerate the YAML and generated Swift API files from the generator output.
- Do not hand-edit generated YAML to “fix” drift. Fix the generator so it produces the desired contract.

### 3.6 Validation and errors

- Reuse existing typed errors and factories where they already exist.
- Prefer explicit, typed error creation over ad hoc stringly-typed errors.
- Keep validation logic in the layer that owns the rule.

### 3.7 Swift function formatting

- Format Swift function declarations so the function name and opening `(` stay on the first line.
- Put every parameter on its own line, indented one level inside the parentheses.
- Separate parameters with `,` except for the last parameter, which must not have a trailing comma.
- Keep the closing `)` and any `async`, `throws`, and return type on the same line as the opening `{`.
- Use this shape consistently, including empty parameter lists:

```swift
func fetchPermissions(
    // empty
) async throws -> [Components.Schemas.SystemPermissionListItemSchema] {

func delete(
    pair: AdminEditAuthAccessControlPair
) async throws {
```

## 4) Editing rules for agents

- Read only what is needed before changing code.
- Keep changes focused and reviewable.
- Prefer small patches over broad refactors.
- Do not modify unrelated files.
- Preserve existing naming and layout conventions unless the task explicitly asks for a structural change.
- If a change affects behavior, add or update the smallest relevant tests.

## 5) Validation expectations

- Run the smallest relevant checks for the touched area when practical.
- Prefer targeted tests first, then broader validation only if needed.
- If validation cannot be completed, state the limitation clearly.

## 6) Collaboration rule

- Before making changes, briefly state the plan: scope, files, and risk.
- Keep progress updates concise.
- Be explicit about any assumption that affects the final result.
