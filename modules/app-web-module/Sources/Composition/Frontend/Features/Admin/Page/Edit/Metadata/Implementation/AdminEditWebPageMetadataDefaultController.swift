import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminEditWebPageMetadataDefaultController:
    AdminEditWebPageMetadataController
{
    let apiBuilder: WebAPIBuilder
    let renderingEngine: any RenderingEngine
    let adminEvents: any EventPublisher

    private func makeHandler() -> AdminWebMetadataEditHandler {
        AdminWebMetadataEditHandler(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine,
            adminEvents: adminEvents
        )
    }

    private func configuration(
        context: AuthenticatedRequestContext
    ) throws -> AdminWebMetadataEditConfiguration {
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
            breadcrumb: WebPageRoutes.breadcrumb,
            navigationTabs: [
                .init(
                    label: "Details",
                    href: WebPageRoutes.edit(RouterPath(pageID)).description,
                    isCurrent: false
                ),
                .init(
                    label: "Metadata",
                    href:
                        WebPageRoutes.metadata(
                            RouterPath(pageID),
                            RouterPath(metadataID)
                        )
                        .description,
                    isCurrent: true
                ),
            ]
        )
    }

    func getEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let handler = makeHandler()
        let configuration = try configuration(context: context)
        return try await handler.get(
            request: request,
            context: context,
            configuration: configuration
        )
    }

    func postEditWebPageMetadata(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let handler = makeHandler()
        let configuration = try configuration(context: context)
        return try await handler.post(
            request: request,
            context: context,
            configuration: configuration
        )
    }

}
