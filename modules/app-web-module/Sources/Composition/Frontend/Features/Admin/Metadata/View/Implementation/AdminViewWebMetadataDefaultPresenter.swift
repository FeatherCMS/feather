import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebMetadataDefaultPresenter: AdminViewWebMetadataPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMetadataDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Web metadata details",
            content: WebMetadataDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: WebMetadataRoutes.breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Web metadata details",
            content: WebMetadataError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMetadataRoutes.breadcrumb
                )
            )
        )
    }

}
