import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebModule

extension Page.Edit.Metadata.Controller {
    struct Default: Interface {
        private let handler: WebModule.Metadata.Edit.Handler
        private let routes: Page.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            events: any EventPublisher,
            routes: Page.Router.Routes
        ) {
            self.handler = WebModule.Metadata.Edit.Handler(
                environment: environment,
                renderingEngine: renderingEngine,
                adminEvents: events
            )
            self.routes = routes
        }

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            try await handler.get(
                request: request,
                context: context,
                configuration: try configuration(context: context)
            )
        }

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            try await handler.post(
                request: request,
                context: context,
                configuration: try configuration(context: context)
            )
        }

        private func configuration(
            context: AuthenticatedRequestContext
        ) throws -> WebModule.Metadata.Edit.Configuration {
            let pageID = try context.requiredID()
            let metadataID =
                context.parameters.get("metadataID", as: String.self) ?? ""
            return .init(
                referenceType: "web.page",
                title: "Edit page",
                description:
                    "Update the page content and publication settings.",
                breadcrumb: routes.breadcrumb,
                navigationTabs: [
                    .init(
                        label: "Details",
                        href: routes.editPath(pageID),
                        isCurrent: false
                    ),
                    .init(
                        label: "Metadata",
                        href: routes.metadataPath(
                            pageID: pageID,
                            metadataID: metadataID
                        ),
                        isCurrent: true
                    ),
                ]
            )
        }
    }
}
