import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditPageDefaultPresenter: AdminEditPagePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: PageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit page",
            content: PageEdit(
                state: .init(
                    id: id,
                    form: state,
                    breadcrumb: PageRoutes.breadcrumb
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
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit page",
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
