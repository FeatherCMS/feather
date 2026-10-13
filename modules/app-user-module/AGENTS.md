# Admin User Frontend Module Guide

Admin user frontend features follow the same operation boundaries as the
system module:

- `Add`, `Edit`, `Get`, `List`, and `Remove` each have `Abstraction/` and
  `Implementation/` folders. Implementation-owned models and views live under
  `Implementation/Models/` and `Implementation/Views/`.
- The operation composition file wires the controller, interactor, repository,
  and presenter.
- Shared route helpers live beside the operation folders; shared user payload
  models and forms live under `Shared/Models/` and `Shared/Views/`. Generic
  form fields belong to the `FeatherAdmin` NewAdmin design system, not to the
  user module.

The user module overview follows the system module convention:
`Overview/Get/{Abstraction,Implementation}`.

The request flow is Router → Controller → Interactor → OpenAPI Repository →
shared API client. Controllers own route parameters, permissions, decoding,
nonce consumption, validation, and error branching. Interactors translate
`OpenAPIRepositoryError` into operation-specific errors. Presenters own
user-facing wording, HTML, response status codes, and success redirects.

Use `NewAdmin` components for all user-facing admin UI. Do not use legacy page,
form, table, breadcrumb, navigation, or toast components. Views receive
prepared state and permissions; they do not perform API calls or permission
decisions beyond rendering the supplied action set.

Form inputs contain only feature fields. Wrap them with
`NonceRequest<Input>` at the controller boundary. Repositories must handle all
documented generated response cases and must not discard mutation responses.
List and remove flows must preserve pagination/search context, use
`NewAdminListActions`, and render appropriate HTTP statuses for unauthorized,
forbidden, not-found, conflict, unavailable, invalid-nonce, and validation
failures.
