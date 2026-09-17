import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditWebMenuDefaultPresenter: AdminEditWebMenuPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: WebMenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: WebMenuEdit(
                state: .init(
                    id: id,
                    form: state,
                    breadcrumb: WebMenuRoutes.breadcrumb
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
            title: "Edit menu",
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
