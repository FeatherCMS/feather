# Admin User Frontend Module Guide

The user module follows the system module's layer, target, namespace, and
operation conventions. Admin UI code lives in `Sources/Composition/WebAdmin`.
Feature routes are grouped by entity and operation, for example
`Routes/Identity/List` and `Routes/Role/Edit`; keep each operation's files flat
and use names such as `Identity+List+Controller+Default.swift`.

Use nested Swift namespaces for operation types, for example
`Identity.List.Controller.Interface|Default`,
`Identity.List.Interactor.Interface|Default`,
`Identity.List.Repository.Interface|OpenAPI`, and `Identity.List.Router`.
Keep the composition router responsible for constructing its dependencies and
registering its route. Pass `AppEnvironment` through routers and create API
clients at the request-context boundary so each request supplies its own auth
context. Do not add compatibility aliases when renaming module APIs.

The request flow is Router → Controller → Interactor → OpenAPI Repository →
API client. Controllers own route parameters, permissions, decoding,
nonce consumption, validation, and error branching. Interactors translate
`OpenAPIRepositoryError` into operation-specific errors. Presenters own
user-facing wording, HTML, response status codes, and success redirects.

Use `Admin` components for all user-facing admin UI. Do not use legacy page,
form, table, breadcrumb, navigation, or toast components. Views receive
prepared state and permissions; they do not perform API calls or permission
decisions beyond rendering the supplied action set.

Form inputs contain only feature fields. Wrap them with
`NonceRequest<Input>` at the controller boundary. Repositories must handle all
documented generated response cases and must not discard mutation responses.
List and remove flows must preserve pagination/search context, use
`AdminListActions`, and render appropriate HTTP statuses for unauthorized,
forbidden, not-found, conflict, unavailable, invalid-nonce, and validation
failures.
