import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebPageDefaultPresenter: AdminViewWebPagePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Web page details",
            content: WebPageDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: WebPageRoutes.breadcrumb,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Web page details",
            content: WebPageError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: WebPageRoutes.breadcrumb
                )
            )
        )
    }

}
