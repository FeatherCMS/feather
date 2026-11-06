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
| `AdminMenuProvider` | `AdminEventContext` | `frontend` | `feather-core` | `[AdminMenuDefinition]` | Contributes top-level admin menu definitions, including grouping, labels, icons, links, priorities, and permissions. | Triggered by `AdminMenuCatalog` and the admin sidebar. Registered by `cms-account-module`, `cms-analytics-module`, `cms-auth-module`, `cms-blog-module`, `cms-contact-module`, `cms-media-module`, `cms-news-module`, `cms-newsletter-module`, `cms-redirect-module`, `cms-system-module`, `cms-user-module`, and `cms-web-module`. |
| `AdminMenuItemProvider` | `AdminEventContext` | `frontend` | `feather-core` | `[AdminMenuItemDefinition]` | Contributes items to one admin menu. The event contains the target `menuKey`. | Triggered while building the admin menu catalog/sidebar. Registered by the same admin modules as `AdminMenuProvider`, with module-specific filtering by `menuKey`. |
| `AdminHomeOverviewProvider` | `AdminDashboardEventContext` | `frontend` | `cms-system-module` | `[AdminHomeOverviewDefinition]` | Supplies dashboard overview cards/widgets for the admin home page. | Triggered by the dashboard interactor. Registered by `cms-analytics-module`, `cms-blog-module`, `cms-redirect-module`, and `cms-web-module`. |
| `AdminRichContentEditorBlockProvider` | `AdminEventContext` | `frontend` | `feather-core` | `AdminRichContentEditorBlockDefinition?` | Extends the rich content editor toolbar and parser with module-owned blocks. | Triggered during application startup to build the editor catalog. Registered by `cms-contact-module` and `cms-newsletter-module`. |
| `TemplateProviderEvent` | `WebModule.Event.Context` | `frontend` | `cms-web-module` | `any TemplateProvider` | Provides public template metadata and bundled template paths to the web application. | Triggered while building web metadata/template definitions. Registered by `cms-web-module`, `cms-blog-module`, and `cms-news-module`. |
| `PublicContentProvider` | `PublicContentEventContext<PublicContentRuntimeContext>` | `frontend` | `cms-web-module` | `PublicContentResult?` | Adds site, page, feature, and template-specific context while rendering a public route. Multiple providers contribute independent payload fragments. | Triggered by `Public.Content.Interactor.Default`; also used by custom public routes that need the shared site context. Registered by `cms-web-module`, `cms-blog-module`, and `cms-news-module`. |
| `RSSContentProvider` | `RSSContentEventContext<PublicContentRuntimeContext>` | `frontend` | `cms-web-module` | `[RSSItem]` | Supplies items for the public RSS feed. | Triggered by the public RSS interactor. Registered by `cms-news-module`. |
| `WebMarkdownBlockRendererProvider` | `WebMarkdownBlockRendererRequest` | `frontend` | `cms-web-module` | `WebMarkdownBlockRenderer?` | Resolves a renderer for a named Markdown block/directive, such as `Grid`, `Cell`, `Video`, `ContactForm`, or `NewsletterCampaign`. | Triggered by `DefaultMarkdownRenderer` for each block. Core web renderers are registered by `cms-web-module`; Contact and Newsletter renderers are registered by their respective modules. |
| `WebMarkdownSourceTransformerProvider` | `WebMarkdownSourceTransformerRequest` | `frontend` | `cms-web-module` | `WebMarkdownSourceTransformer?` | Provides a pre-render Markdown transformation stage for normalizing or extending source content before parsing. | Triggered by `DefaultMarkdownRenderer`. No production handler registration was found in the audited source; this is currently an available extension point. |

## Backend events

| Event | Context | Platform | Defined in | Output | Description | Current wiring / consumers |
| --- | --- | --- | --- | --- | --- | --- |
| `AccessControlProvider` | `AccessControlContext` | `backend` | `feather-core` | `[PermissionKey]` | Provides role-specific permissions used when building access-control records. The event carries the `roleKey`. | Triggered during access-control seeding. Registered by `cms-system-module`, `cms-media-module`, and `cms-web-module`; handlers currently grant editor permissions for their module. |
| `PermissionSeedProvider` | `EventContext` | `backend` | `cms-system-module` | `[PermissionSeedDefinition]` | Contributes permissions that must be inserted during a clean database seed. | Triggered by `SystemInfrastructure.TableSeedMigration`. Registered by the system, account, analytics, auth, blog, contact, media, news, newsletter, redirect, user, and web modules. |
| `VariableSeedProvider` | `EventContext` | `backend` | `cms-system-module` | `[VariableSeedDefinition]` | Contributes application/system configuration variables for database seeding. | Triggered by `SystemInfrastructure.TableSeedMigration`. Registered by `cms-blog-module`, `cms-news-module`, and `cms-web-module`. |
| `MailFromAddressProvider` | `EventContext` | `backend` | `cms-system-module` | `MailFromAddressProvider.Output` | Supplies the canonical sender email and optional display name used for system-generated mail. | Triggered by `SystemInfrastructure.MailFromVariableMigration`. Registered by the application in `FeatherMailFromAddressEventHandlers`. The migration requires exactly one provider result. |
| `UserRoleSeedProvider` | `UserEventContext` | `backend` | `cms-user-module` | `[UserRoleSeedDefinition]` | Supplies initial user roles, including their keys and names. | Triggered by `UserInfrastructure.TableSeedMigration`. Registered by `cms-user-module`. |
| `UserIdentitySeedProvider` | `UserEventContext` | `backend` | `cms-user-module` | `[UserIdentitySeedDefinition]` | Supplies initial user identities, including generated IDs, status, root status, and role keys. | Triggered by `UserInfrastructure.TableSeedMigration`. Registered by `cms-user-module`; the context provides the shared `IDGenerator`. |
| `UserIdentityDidInsert` | `DatabaseTransactionContext` | `backend` | `cms-user-module` | `Void` | Notifies backend modules that a user identity was inserted. The event carries the new `identityID` and runs inside the active database transaction. | Triggered by identity creation, account creation/invitation, and identity seeding. Registered by `cms-account-module`, which creates the related account settings/profile records using the same transaction context. |
| `AccountSeedProvider` | `EventContext` | `backend` | `cms-account-module` | `[AccountSeedDefinition]` | Supplies initial accounts with email, password, and role keys for clean-install seeding. | Triggered by `AccountInfrastructure.TableSeedMigration`. No production provider registration was found in the audited Feather source; an application must register one if it wants seeded accounts. |
| `Menu.Provider` | `WebSeedEventContext` | `backend` | `cms-web-module` | `[Menu.Definition]` | Contributes public menu definitions, including menu keys, names, and notes. | Triggered by `WebInfrastructure.TableSeedMigration`. Registered by `cms-web-module`; application modules can add additional menu providers. |
| `MenuItem.Provider` | `WebSeedEventContext` | `backend` | `cms-web-module` | `[MenuItem.Definition]` | Contributes items to a named public menu during seeding. Items can carry priority, authentication, permission, external-link, and notes metadata. | Triggered once per seeded menu by `WebInfrastructure.TableSeedMigration`. Registered by `cms-web-module` and `cms-blog-module` in Feather. |
| `Page.Provider` | `WebSeedEventContext` | `backend` | `cms-web-module` | `[Page.Definition]` | Contributes initial public pages and their content/metadata for database seeding. | Triggered by `WebInfrastructure.TableSeedMigration`. Registered by `cms-web-module` and `cms-blog-module`. |

## Context catalogue

All event contexts conform to `ExecutionContext`. The registry uses the
concrete context type when selecting a handler.

### Empty contexts

These concrete contexts currently carry no stored properties and have only a
parameterless initializer:

| Context | Defined in | Used by | Notes |
| --- | --- | --- | --- |
| `AccessControlContext` | `feather-core` | `AccessControlProvider` | Marker context for access-control providers. |
| `EventContext` | `cms-system-module` | Permission, variable, and mail-from seed providers | General-purpose backend context. |
| `WebModule.Event.Context` | `cms-web-module` | `TemplateProviderEvent` | Marker context for web-composition events. |
| `WebSeedEventContext` | `cms-web-module` | `Menu.Provider`, `MenuItem.Provider`, `Page.Provider` | Marker context for backend web-seeding providers. |
| `WebMarkdownSourceTransformerRequest` | `cms-web-module` | `WebMarkdownSourceTransformerProvider` | Empty request context for source-transformer extensions. |

`ExecutionContext` itself is also a marker protocol with no members, but it is
not a concrete context and is therefore not included in the list above.

| Context | Defined in | Payload | Used by |
| --- | --- | --- | --- |
| `EventContext` | `cms-system-module` | No fields; general backend/application context. | Permission, variable, mail-from, and other simple seed providers. |
| `AccessControlContext` | `feather-core` | No fields. | `AccessControlProvider`. |
| `AdminEventContext` | `feather-core` | Current admin `path` and the caller's `permissions`. | Admin menu and rich-content-editor providers. |
| `AdminDashboardEventContext` | `cms-system-module` | API base URL, optional session token, permissions, and the dashboard `from`/`to` time range. | `AdminHomeOverviewProvider`. |
| `UserEventContext` | `cms-user-module` | Shared `IDGenerator`. | User role and identity seed providers. |
| `DatabaseTransactionContext` | `feather-core` | Active database `connection` and shared `IDGenerator`. | Transaction-bound events such as `UserIdentityDidInsert`. Must not escape the transaction lifetime. |
| `DatabaseQueryContext` | `feather-core` | Active database `connection`. | Query-scoped contextual execution; no current event registration was found that uses it directly. |
| `WebSeedEventContext` | `cms-web-module` | No fields; backend web-seeding context. | Public menu, menu-item, and page seed providers. |
| `WebModule.Event.Context` | `cms-web-module` | No fields; web-composition context. | Web template providers. |
| `PublicContentEventContext<T>` | `cms-web-module` | Base route metadata plus a generic runtime value. In the application, `T` is `PublicContentRuntimeContext`, containing request, request context, API base URL, public origins, and media resolver. | Public content providers. |
| `RSSContentEventContext<T>` | `cms-web-module` | Generic runtime value; in the application this is `PublicContentRuntimeContext`. | RSS content providers. |
| `WebMarkdownBlockRendererRequest` | `cms-web-module` | Parsed directive arguments, child blocks, optional form-submission nonce, and form feedback. | Markdown block renderer providers. |
| `WebMarkdownSourceTransformerRequest` | `cms-web-module` | No fields. | Markdown source transformer providers. |

## Registration and trigger conventions

Handlers are registered against an `EventRegistry` using both the event type
and context type:

```swift
registry.register(
    event: MenuItem.Provider.self,
    context: WebSeedEventContext.self
) { event, context in
    // return [MenuItem.Definition]
}
```

The event is triggered through the `EventPublisher` abstraction:

```swift
let results = try await events.trigger(
    event: MenuItem.Provider(menuKey: "main"),
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
