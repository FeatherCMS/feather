import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebMenuDefaultPresenter: AdminViewWebMenuPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Menu details",
            content: WebMenuDetails(
                state: .init(
                    menu: rule,
                    breadcrumb: WebMenuRoutes.breadcrumb,
                    permissions: permissions
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
            title: "Menu details",
            content: WebMenuError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebMenuRoutes.breadcrumb
                )
            )
        )
    }

}
