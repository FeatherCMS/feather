# Newsletter Module Guide

## Module structure and ownership

- Keep `NewsletterModule`, `NewsletterDomain`, `NewsletterApplication`,
  `NewsletterInfrastructure`, `NewsletterAdminAPI`, `NewsletterAppAPI`,
  `NewsletterBackend`, `NewsletterWebShared`, `NewsletterWebAdmin`, and
  `NewsletterWebApp` in their existing separate targets.
- Keep `Campaign`, `Issue`, `Delivery`, and `Subscriber` as the entity
  namespaces throughout Module, Domain, Application, Infrastructure, and
  generator source. The word `Newsletter` may remain in public OpenAPI
  component identifiers and operation IDs; it is not an extra entity namespace.
- Newsletter owns separate Admin and App APIs. Keep management and delivery
  operations in Admin, and public subscription/unsubscription in App.

## Application and persistence

- Keep each provided `List`, `Search`, `Detail`, and mutation operation
  separate. `List` is for lightweight selectors; where structured, paginated
  table search is needed, use `Search`. Do not combine their query contracts
  or reuse list schemas for query responses, and do not add an endpoint without
  a corresponding use-case.
- Keep campaign, issue, delivery, and subscriber behavior under their own
  use-case namespaces and operation-specific scopes. Keep sending/test-email
  behavior in the relevant Issue operation and public subscription behavior in
  the corresponding Campaign operation.
- Use FeatherDBAL tables, rows, and migrations for standard persistence. Keep
  cross-entity/association tables separately named and scoped; put custom SQL
  only in Infrastructure `Database/AccessLayer` when DBAL is insufficient.
- Use mock database/DBAL tests for ordinary infrastructure and HTTP tests.
  Migration tests should verify columns, timestamps, defaults, keys, and
  indexes; application tests should verify transaction, mail, event, and
  authorization behavior without relying on HTTP tests.

## Backend and web composition

- `NewsletterBackend` owns Admin/App gateways and use-case construction. Keep
  request/response mapping beside its gateway operation; do not create
  standalone mappings files.
- Keep public subscription routes and App clients in `NewsletterWebApp`;
  management routes/events/clients in `NewsletterWebAdmin`; place only
  surface-neutral helpers in `NewsletterWebShared`.
- WebAdmin route features use the entity/operation namespace with
  `Controller`, `Interactor`, `Presenter`, `Repository`, and `Router` as
  needed. Routers own handler construction and route registration; use
  `WebRoute` and pass `AppEnvironment` through the router tree.
- Keep transport adapters named `Repository`. Use the generated Query endpoint
  for tables and List for lightweight selectors; map API schemas at the
  `Repository.OpenAPI` boundary.

## API generation and validation

- Keep generator namespaces and source filenames aligned to `Campaign`,
  `Issue`, `Delivery`, and `Subscriber`; merge each entity PathCollection from
  the API-level collection. Preserve existing public OpenAPI component IDs and
  operation IDs. Regenerate YAML and Swift API files via the checked-in
  workflow; do not edit generated output by hand.
- Do not add direct package dependencies for every import. Add a direct product
  only when SwiftPM/compiler diagnostics require it and remove unused products.
- The repository-level `AGENTS.md` prohibits running builds, tests, and other
  validations in agent workflows. Record needed checks in the handoff; do not
  execute them here.
