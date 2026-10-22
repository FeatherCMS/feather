import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminAddMenuDefaultPresenter: AdminAddMenuPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: MenuForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Add menu",
            content: MenuAdd(
                state: .init(
                    form: state,
                    breadcrumb: MenuRoutes.breadcrumb
                )
            )
        )
    }

}
