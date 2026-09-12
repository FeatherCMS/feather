# Admin Web Feature Module Guide

This folder is the reference implementation for an admin web frontend feature
module. New CRUD-style admin features should follow this structure unless the
feature has materially different requirements.

## Feature shape

Create one directory for each user-facing operation:

- `Add`
- `Edit`
- `Get`
- `List`
- `Remove`

Each operation is split into:

- `Abstraction/` — controller, interactor, presenter, and repository protocols.
- `Implementation/` — default implementations, OpenAPI repository, models, and views.
- A feature composition file — for example `AdminAddSystemVariable.swift` — that wires the runtime dependencies.

Keep cross-operation route definitions in a sibling `<Feature>Routes.swift`
file. Keep operation-specific models and views inside the operation directory.

## Models and views

Models describe feature-local state and transport results; they do not render
HTML or perform request orchestration. Keep form input models, validation
extensions, edit/get models, and list state models in the operation's
`Implementation/Models/` directory.

Views are `Component` types responsible only for rendering the supplied state.
Use dedicated page, form, table, row, and details components where the view
has a distinct responsibility. Keep permission decisions and API calls out of
views; pass already-prepared state and action permissions into them.

Use the existing `NewAdmin` design-system components for admin UI, including
breadcrumbs, page headers, forms, fields, buttons, tables, list actions,
pagination, empty states, status pages, confirmations, and notifications.
Do not invent or duplicate UI components, styles, or markup when an existing
`NewAdmin` component provides the required behavior. Create a new component
only when the feature explicitly requires UI that the existing components
cannot represent.

When a new component is explicitly required, place it at the narrowest feature
scope that needs it, keep it state-driven, and follow the existing component
selector and accessibility conventions.

## Request flow

Use this direction for every operation:

```text
Router
  -> Controller
  -> Interactor
  -> OpenAPI Repository
  -> Shared API client
```

The response path reverses the direction:

```text
Shared API client
  -> Repository model
  -> Presenter
  -> HTML component
  -> HTMLResponse / redirect
```

Controllers should remain thin. They are responsible for request decoding,
route parameters, permission gates, nonce handling, error branching, and
delegating to the interactor/presenter. They should not contain API mapping or
HTML construction.

Interactors coordinate one operation and normalize form input before passing it
to the repository. They should not know about HTTP, routing, or HTML.

Repositories translate generated OpenAPI request and response types into
feature-local models and map all documented response statuses to
`OpenAPIRepositoryError`. Do not discard response enums from mutating API
calls.

## Composition and runtime wiring

The operation-level composition file constructs the default controller with a
`buildRuntime` closure. The closure receives the request and context and builds:

1. The OpenAPI repository from `context.systemAdminAPI()`.
2. The default interactor with that repository.
3. The default presenter with the request, context, and rendering engine.

Keep this wiring isolated from the controller and interactor. Do not introduce
global state or put feature behavior on the request context.

## Permissions

Every operation must enforce its own permission in the controller before doing
work:

- Add: `create`
- Edit: `update`
- Get: `read`
- List: `list`
- Remove: `delete`

Use `context.isCurrentUserAllowed(to:)` for individual gates. Use
`context.currentUserAdminListActions` when a view needs multiple action checks.
Do not manually convert `Set<String>` permission values in feature code.

Permission denial for an HTML page should render a presenter-provided
`NewAdminStatusView`. Invalid nonces remain request-level forbidden errors.
List, details, edit, and remove views must not display actions the current user
cannot execute.

## Add and edit forms

The standard field order for variables and similar configuration records is:

```text
Key -> Value -> Name -> Notes
```

Keep the following concerns separate:

- `FormInput.swift` — Codable request payload and normalized values.
- `FormInput+Validation.swift` — frontend validation rules.
- `Form.swift` — field state, field order, rendering, and form actions.
- `Page.swift` — breadcrumb, page header, and form composition.

Only fields that are actually required should set `isRequired: true` and
`required: true`. Keep these two declarations consistent. Optional empty text
fields should normalize through the feature's `emptyToNil` convention where
the API model is nullable.

When validation fails, preserve the submitted normalized values and attach
failures to the matching field names. Shared input and textarea components
already render field errors in red and expose them through
`aria-errormessage`; use the field state error rather than rendering ad hoc
error markup.

## List, details, and empty values

The list operation should pass page and search state through the repository,
interactor, presenter, table, pagination, remove form, and redirects.

Use `NewAdminListActions` for list row actions, toolbar actions, selection, and
detail-page actions. Build actions conditionally rather than filtering by
button labels.

When a nullable or empty value is displayed to an administrator, use `—` so
unset data is distinguishable from missing markup. For strings where whitespace
only should count as empty, use `emptyToNil`.

## Remove flow

Removal is a two-step flow:

1. GET confirmation page with selected IDs and origin context.
2. POST nonce-protected deletion, then redirect with a flash notification.

Encode IDs with the route helper. Preserve list page/search state. Track the
origin explicitly when removal starts from details or edit so cancellation
returns to the correct page; list-originated cancellation returns to the list.

Confirmation labels should prefer display name, then key, then a diagnostic
fallback. A missing optional name does not mean the entity is missing.

## Status and error handling

Present user-facing API failures with the operation presenter and
`NewAdminStatusView`. Include a useful title, message, and cancel destination
for destructive flows. Handle documented OpenAPI statuses explicitly, including
unauthorized, forbidden, not found, and conflict/undocumented responses.

Use direct `HTTPError` only for request-level failures such as invalid route
parameters or failed nonce validation, unless the feature's established
middleware requires another behavior.

## Naming and file rules

- Prefix operation types with `Admin<Operation>System<Feature>`.
- Name default implementations `...DefaultController`, `...DefaultInteractor`, and `...DefaultPresenter`.
- Name API adapters `...OpenAPIRepository`.
- Name HTML components after the rendered page, form, table, row, or details view.
- Keep one primary object per file.
- Do not place SQL, backend use cases, or domain models in this frontend folder.

## Completion checklist

Before considering a feature complete, verify:

- All operation routes are registered.
- Every operation has abstraction and default implementation layers.
- Composition creates the repository, interactor, and presenter.
- Permissions are enforced and unauthorized actions are hidden.
- Forms normalize and validate consistently.
- Field errors are attached to the correct fields and remain accessible.
- List pagination/search state survives navigation and removal.
- Empty values display as `—` where appropriate.
- API response statuses are not discarded.
- Remove cancellation returns to the correct origin.
- The owning Swift package builds successfully.
