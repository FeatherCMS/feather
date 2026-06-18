import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddWebMenuDefaultPresenter: AdminAddWebMenuPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: WebMenuForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add menu - Feather CMS",
            description: "Add a menu in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMenuAdd(
                state: .init(
                    form: state,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Menus", link: "/admin/web/menus/"),
                .init(label: "Add", link: "/admin/web/menus/add/"),
            ]
        )
    }
}
