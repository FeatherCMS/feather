import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewPageDefaultPresenter: AdminViewPagePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: PageDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Web page details",
            content: PageDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: PageRoutes.breadcrumb,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        permissions: AdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Web page details",
            content: PageError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: PageRoutes.breadcrumb
                )
            )
        )
    }

}
