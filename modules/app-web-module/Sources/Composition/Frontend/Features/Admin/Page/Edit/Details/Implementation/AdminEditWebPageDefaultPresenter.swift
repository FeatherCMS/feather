import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditWebPageDefaultPresenter: AdminEditWebPagePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: WebPageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit page",
            content: WebPageEdit(
                state: .init(
                    id: id,
                    form: state,
                    breadcrumb: WebPageRoutes.breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit page",
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
