import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveWebPageDefaultPresenter:
    AdminRemoveWebPagePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove page",
            content: WebPageConfirmation(
                state: .init(
                    id: item.id,
                    source: item.label,
                    breadcrumb: WebPageRoutes.breadcrumb,
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove page",
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
