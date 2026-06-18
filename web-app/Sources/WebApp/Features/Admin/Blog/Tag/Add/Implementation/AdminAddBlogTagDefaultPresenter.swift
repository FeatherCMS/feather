import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddBlogTagDefaultPresenter: AdminAddBlogTagPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogTagForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add tag - Feather CMS",
            description: "Add a tag in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagAdd(
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
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Tags", link: "/admin/blog/tags/"),
                .init(label: "Add", link: "/admin/blog/tags/add/"),
            ]
        )
    }
}
