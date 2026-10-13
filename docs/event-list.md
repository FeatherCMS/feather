# Feather event list

This is the source-oriented inventory of Feather's application events and the
contexts accepted by their handlers. It covers the event contracts and
production registrations under `feather-core`, `modules/*`, and
`application/Sources`. Test-only events are intentionally excluded.

## How to read this list

- `frontend` events extend admin or public-web composition and rendering.
- `backend` events extend migrations, seed data, authorization, or application
  use cases.
- `Defined in` identifies the package that owns the event contract. A handler
  can be registered by another module.
- A provider event may have multiple handlers. `Current wiring / consumers`
  records the important production registrations and trigger sites found in
  the source audit.

The event registry is typed by both event and context. A handler registered for
`EventContext` is not the same registration as one registered for
`DatabaseTransactionContext`, even when the event type is the same.

## Frontend events

| Event | Context | Platform | Defined in | Output | Description | Current wiring / consumers |
| --- | --- | --- | --- | --- | --- | --- |
| `AdminMenuProvider` | `AdminEventContext` | `frontend` | `feather-core` | `[AdminMenuDefinition]` | Contributes top-level admin menu definitions, including grouping, labels, icons, links, priorities, and permissions. | Triggered by `AdminMenuCatalog` and the admin sidebar. Registered by `app-account-module`, `app-analytics-module`, `app-auth-module`, `app-blog-module`, `app-contact-module`, `app-media-module`, `app-news-module`, `app-newsletter-module`, `app-redirect-module`, `app-system-module`, `app-user-module`, and `app-web-module`. |
| `AdminMenuItemProvider` | `AdminEventContext` | `frontend` | `feather-core` | `[AdminMenuItemDefinition]` | Contributes items to one admin menu. The event contains the target `menuKey`. | Triggered while building the admin menu catalog/sidebar. Registered by the same admin modules as `AdminMenuProvider`, with module-specific filtering by `menuKey`. |
| `AdminHomeOverviewProvider` | `AdminDashboardEventContext` | `frontend` | `app-system-module` | `[AdminHomeOverviewDefinition]` | Supplies dashboard overview cards/widgets for the admin home page. | Triggered by the dashboard interactor. Registered by `app-analytics-module`, `app-blog-module`, `app-redirect-module`, and `app-web-module`. |
| `AdminRichContentEditorBlockProvider` | `AdminEventContext` | `frontend` | `feather-core` | `AdminRichContentEditorBlockDefinition?` | Extends the rich content editor toolbar and parser with module-owned blocks. | Triggered during application startup to build the editor catalog. Registered by `app-contact-module` and `app-newsletter-module`. |
| `WebTemplateProviderEvent` | `WebFrontendEventContext` | `frontend` | `app-web-module` | `any WebTemplateProvider` | Provides public template metadata and bundled template paths to the web application. | Triggered while building web metadata/template definitions. Registered by `app-web-module`, `app-blog-module`, and `app-news-module`. |
| `WebPublicContentProvider` | `WebPublicContentEventContext<PublicContentRuntimeContext>` | `frontend` | `app-web-module` | `WebPublicContentResult?` | Adds site, page, feature, and template-specific context while rendering a public route. Multiple providers contribute independent payload fragments. | Triggered by `AppPublicContentDefaultInteractor`; also used by custom public routes that need the shared site context. Registered by `app-web-module`, `app-blog-module`, and `app-news-module`. |
| `WebRSSContentProvider` | `WebRSSContentEventContext<PublicContentRuntimeContext>` | `frontend` | `app-web-module` | `[WebRSSItem]` | Supplies items for the public RSS feed. | Triggered by the public RSS interactor. Registered by `app-news-module`. |
| `WebMarkdownBlockRendererProvider` | `WebMarkdownBlockRendererRequest` | `frontend` | `app-web-module` | `WebMarkdownBlockRenderer?` | Resolves a renderer for a named Markdown block/directive, such as `Grid`, `Cell`, `Video`, `ContactForm`, or `NewsletterCampaign`. | Triggered by `DefaultMarkdownRenderer` for each block. Core web renderers are registered by `app-web-module`; Contact and Newsletter renderers are registered by their respective modules. |
| `WebMarkdownSourceTransformerProvider` | `WebMarkdownSourceTransformerRequest` | `frontend` | `app-web-module` | `WebMarkdownSourceTransformer?` | Provides a pre-render Markdown transformation stage for normalizing or extending source content before parsing. | Triggered by `DefaultMarkdownRenderer`. No production handler registration was found in the audited source; this is currently an available extension point. |

## Backend events

| Event | Context | Platform | Defined in | Output | Description | Current wiring / consumers |
| --- | --- | --- | --- | --- | --- | --- |
| `AccessControlProvider` | `AccessControlContext` | `backend` | `feather-core` | `[PermissionKey]` | Provides role-specific permissions used when building access-control records. The event carries the `roleKey`. | Triggered during access-control seeding. Registered by `app-system-module`, `app-media-module`, and `app-web-module`; handlers currently grant editor permissions for their module. |
| `PermissionSeedProvider` | `EventContext` | `backend` | `app-system-module` | `[PermissionSeedDefinition]` | Contributes permissions that must be inserted during a clean database seed. | Triggered by `SystemInfrastructure.TableSeedMigration`. Registered by the system, account, analytics, auth, blog, contact, media, news, newsletter, redirect, user, and web modules. |
| `VariableSeedProvider` | `EventContext` | `backend` | `app-system-module` | `[VariableSeedDefinition]` | Contributes application/system configuration variables for database seeding. | Triggered by `SystemInfrastructure.TableSeedMigration`. Registered by `app-blog-module`, `app-news-module`, and `app-web-module`. |
| `MailFromAddressProvider` | `EventContext` | `backend` | `app-system-module` | `MailFromAddressProvider.Output` | Supplies the canonical sender email and optional display name used for system-generated mail. | Triggered by `SystemInfrastructure.MailFromVariableMigration`. Registered by the application in `FeatherMailFromAddressEventHandlers`. The migration requires exactly one provider result. |
| `UserRoleSeedProvider` | `UserEventContext` | `backend` | `app-user-module` | `[UserRoleSeedDefinition]` | Supplies initial user roles, including their keys and names. | Triggered by `UserInfrastructure.TableSeedMigration`. Registered by `app-user-module`. |
| `UserIdentitySeedProvider` | `UserEventContext` | `backend` | `app-user-module` | `[UserIdentitySeedDefinition]` | Supplies initial user identities, including generated IDs, status, root status, and role keys. | Triggered by `UserInfrastructure.TableSeedMigration`. Registered by `app-user-module`; the context provides the shared `IDGenerator`. |
| `UserIdentityDidInsert` | `DatabaseTransactionContext` | `backend` | `app-user-module` | `Void` | Notifies backend modules that a user identity was inserted. The event carries the new `identityID` and runs inside the active database transaction. | Triggered by identity creation, account creation/invitation, and identity seeding. Registered by `app-account-module`, which creates the related account settings/profile records using the same transaction context. |
| `AccountSeedProvider` | `EventContext` | `backend` | `app-account-module` | `[AccountSeedDefinition]` | Supplies initial accounts with email, password, and role keys for clean-install seeding. | Triggered by `AccountInfrastructure.TableSeedMigration`. No production provider registration was found in the audited Feather source; an application must register one if it wants seeded accounts. |
| `WebMenuProvider` | `WebSeedEventContext` | `backend` | `app-web-module` | `[WebMenuDefinition]` | Contributes public menu definitions, including menu keys, names, and notes. | Triggered by `WebInfrastructure.TableSeedMigration`. Registered by `app-web-module`; application modules can add additional menu providers. |
| `WebMenuItemProvider` | `WebSeedEventContext` | `backend` | `app-web-module` | `[WebMenuItemDefinition]` | Contributes items to a named public menu during seeding. Items can carry priority, authentication, permission, external-link, and notes metadata. | Triggered once per seeded menu by `WebInfrastructure.TableSeedMigration`. Registered by `app-web-module` and `app-blog-module` in Feather. |
| `WebPageProvider` | `WebSeedEventContext` | `backend` | `app-web-module` | `[WebPageDefinition]` | Contributes initial public pages and their content/metadata for database seeding. | Triggered by `WebInfrastructure.TableSeedMigration`. Registered by `app-web-module` and `app-blog-module`. |

## Context catalogue

All event contexts conform to `ExecutionContext`. The registry uses the
concrete context type when selecting a handler.

### Empty contexts

These concrete contexts currently carry no stored properties and have only a
parameterless initializer:

| Context | Defined in | Used by | Notes |
| --- | --- | --- | --- |
| `AccessControlContext` | `feather-core` | `AccessControlProvider` | Marker context for access-control providers. |
| `EventContext` | `app-system-module` | Permission, variable, and mail-from seed providers | General-purpose backend context. |
| `WebFrontendEventContext` | `app-web-module` | `WebTemplateProviderEvent` | Marker context for frontend web-composition providers. |
| `WebSeedEventContext` | `app-web-module` | `WebMenuProvider`, `WebMenuItemProvider`, `WebPageProvider` | Marker context for backend web-seeding providers. |
| `WebMarkdownSourceTransformerRequest` | `app-web-module` | `WebMarkdownSourceTransformerProvider` | Empty request context for source-transformer extensions. |

`ExecutionContext` itself is also a marker protocol with no members, but it is
not a concrete context and is therefore not included in the list above.

| Context | Defined in | Payload | Used by |
| --- | --- | --- | --- |
| `EventContext` | `app-system-module` | No fields; general backend/application context. | Permission, variable, mail-from, and other simple seed providers. |
| `AccessControlContext` | `feather-core` | No fields. | `AccessControlProvider`. |
| `AdminEventContext` | `feather-core` | Current admin `path` and the caller's `permissions`. | Admin menu and rich-content-editor providers. |
| `AdminDashboardEventContext` | `app-system-module` | API base URL, optional session token, permissions, and the dashboard `from`/`to` time range. | `AdminHomeOverviewProvider`. |
| `UserEventContext` | `app-user-module` | Shared `IDGenerator`. | User role and identity seed providers. |
| `DatabaseTransactionContext` | `feather-core` | Active database `connection` and shared `IDGenerator`. | Transaction-bound events such as `UserIdentityDidInsert`. Must not escape the transaction lifetime. |
| `DatabaseQueryContext` | `feather-core` | Active database `connection`. | Query-scoped contextual execution; no current event registration was found that uses it directly. |
| `WebSeedEventContext` | `app-web-module` | No fields; backend web-seeding context. | Public menu, menu-item, and page seed providers. |
| `WebFrontendEventContext` | `app-web-module` | No fields; frontend web-composition context. | Web template providers. |
| `WebPublicContentEventContext<T>` | `app-web-module` | Base route metadata plus a generic runtime value. In the application, `T` is `PublicContentRuntimeContext`, containing request, request context, API base URL, public origins, and media resolver. | Public content providers. |
| `WebRSSContentEventContext<T>` | `app-web-module` | Generic runtime value; in the application this is `PublicContentRuntimeContext`. | RSS content providers. |
| `WebMarkdownBlockRendererRequest` | `app-web-module` | Parsed directive arguments, child blocks, optional form-submission nonce, and form feedback. | Markdown block renderer providers. |
| `WebMarkdownSourceTransformerRequest` | `app-web-module` | No fields. | Markdown source transformer providers. |

## Registration and trigger conventions

Handlers are registered against an `EventRegistry` using both the event type
and context type:

```swift
registry.register(
    event: WebMenuItemProvider.self,
    context: WebSeedEventContext.self
) { event, context in
    // return [WebMenuItemDefinition]
}
```

The event is triggered through the `EventPublisher` abstraction:

```swift
let results = try await events.trigger(
    event: WebMenuItemProvider(menuKey: "main"),
    using: WebSeedEventContext()
)
```

`EventRegistry` invokes all handlers registered for the event type and returns
their typed outputs in registration order. Seed migrations flatten provider
results before inserting records; public rendering merges provider payloads
into the template context; frontend provider events select or collect runtime
extension implementations.

## Audit notes

- `WebMarkdownSourceTransformerProvider` and `AccountSeedProvider` are defined
  extension points with no production provider registration in Feather's
  audited source.
- The application may register additional handlers in its own module. This
  document records Feather's packages and the `application/Sources` wiring;
  application-specific repositories should update this list when they add
  event contracts or registrations.
- If an event is added, update this document with its concrete context and
  trigger/registration site at the same time as the source change.
