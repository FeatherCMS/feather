import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components

struct AdminAddMenuItemDefaultPresenter: AdminAddMenuItemPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        menuId: String,
        state: MenuItemForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit menu",
            content: MenuItemAdd(
                state: .init(
                    menuId: menuId,
                    form: state,
                    breadcrumb: MenuRoutes.breadcrumb
                )
            )
        )
    }

}
