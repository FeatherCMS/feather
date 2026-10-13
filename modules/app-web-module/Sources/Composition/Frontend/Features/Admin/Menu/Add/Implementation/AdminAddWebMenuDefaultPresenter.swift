import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddWebMenuDefaultPresenter: AdminAddWebMenuPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: WebMenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add menu",
            content: WebMenuAdd(
                state: .init(
                    form: state,
                    breadcrumb: WebMenuRoutes.breadcrumb
                )
            )
        )
    }

}
