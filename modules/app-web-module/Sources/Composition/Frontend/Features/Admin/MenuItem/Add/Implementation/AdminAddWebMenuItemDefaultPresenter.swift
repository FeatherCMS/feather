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
                    breadcrumb: breadcrumb(menuId: menuId)
                )
            )
        )
    }

    func breadcrumb(
        menuId: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(label: "Menu", link: "/admin/web/menus/\(menuId)/"),
                .init(
                    label: "Items",
                    link: "/admin/web/menus/\(menuId)/items/"
                ),
            ]
    }
}
