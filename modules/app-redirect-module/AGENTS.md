# Admin Redirect Frontend Module Guide

Redirect admin features use the same operation boundaries as the system and
user modules. Each `Add`, `Edit`, `Get`, `List`, and `Remove` operation owns
its controller, interactor, repository, presenter, and implementation models
and views where applicable. Operation models and views live under
`Implementation/Models` and `Implementation/Views`; `Abstraction` contains
protocols only.

The module overview lives under `Overview/Get`, with its implementation models
and views under that operation's `Implementation` directory. Each rule
operation owns its feature-specific models and views under that operation's
`Implementation/Models` and `Implementation/Views` directories. Do not create
a `Rule/Shared` folder.

The request flow is Router → Controller → Interactor → OpenAPI Repository →
API client. Controllers own route parameters, permissions, request decoding,
nonce consumption, validation, and error branching. Interactors translate
`OpenAPIRepositoryError` into operation-specific errors. Presenters own
user-facing wording, NewAdmin HTML, response status codes, and redirects.

Use NewAdmin components only. Form inputs contain feature fields only and are
wrapped in `NonceRequest<Input>` at the controller boundary. List and remove
flows preserve pagination, search, and filter state; bulk removal belongs to
the Remove operation and is a single repository call.
