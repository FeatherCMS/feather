import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminAddPageDefaultPresenter: AdminAddPagePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: PageForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Add page",
            content: PageAdd(
                state: .init(
                    form: state,
                    breadcrumb: PageRoutes.breadcrumb
                )
            )
        )
    }

}
