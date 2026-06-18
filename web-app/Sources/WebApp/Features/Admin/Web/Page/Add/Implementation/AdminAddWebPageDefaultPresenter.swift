import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddWebPageDefaultPresenter: AdminAddWebPagePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: WebPageForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add page - Feather CMS",
            description: "Add a page in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebPageAdd(
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
                .init(label: "Pages", link: "/admin/web/pages/"),
                .init(label: "Add", link: "/admin/web/pages/add/"),
            ]
        )
    }
}
