import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

struct AdminEditPageMetadataDefaultController:
    AdminEditPageMetadataController
{
    let environment: AppEnvironment
    let renderingEngine: any RenderingEngine
    let adminEvents: any EventPublisher
    let routes: Page.Router.Routes

    private func makeHandler() -> AdminMetadataEditHandler {
        AdminMetadataEditHandler(
            environment: environment,
            renderingEngine: renderingEngine,
            adminEvents: adminEvents
        )
    }

    private func configuration(
        request: Request,
        context: AuthenticatedRequestContext
    ) throws -> AdminMetadataEditConfiguration {
        let pageID = try context.requiredID()
        let metadataID =
            context.parameters.get(
                "metadataID",
                as: String.self
            ) ?? ""
        return .init(
            referenceType: "web.page",
            title: "Edit page",
            description: "Update the page content and publication settings.",
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

    func getEditPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let handler = makeHandler()
        let configuration = try configuration(
            request: request,
            context: context
        )
        return try await handler.get(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    func postEditPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let handler = makeHandler()
        let configuration = try configuration(
            request: request,
            context: context
        )
        return try await handler.post(
            request: request,
            context: context,
            configuration: configuration
        )
    }

}
