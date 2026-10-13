# News module

The News module provides article and category domain models, use cases, persistence, public rendering, and optional admin CRUD APIs and pages.

The admin surface is opt-in at application composition:

- Register `NewsBackend.AdminAPIGateway(useCases:)` for the generic admin API.
- Register `AdminNews(apiBuilder:renderingEngine:)` for the admin routes.
- Register `NewsAdminMenuEventHandlers` for the News child menu entries.
- Register `NewsAdminMenuProvider` to add the standard News parent menu. This is optional when an application already provides its own `news` parent menu.

Applications can compose the domain, application, and infrastructure products without registering the generic admin gateway or frontend routes when they need a different API or admin experience. The existing News table migration remains the only schema migration; the admin integration adds no tables or seed records.

Run `make openapi` to generate the News Admin and App OpenAPI YAML and Swift API types. `make docker-openapi` serves both API specifications through Swagger UI.
