import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddWebMenuItemDefaultPresenter: AdminAddWebMenuItemPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        menuId: String,
        state: WebMenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add item",
            content: WebMenuItemAdd(
                state: .init(
                    menuId: menuId,
                    form: state,
                    breadcrumb: WebMenuItemRoutes.breadcrumb(RouterPath(menuId))
                )
            )
        )
    }

}
