import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddBlogAuthorDefaultPresenter: AdminAddBlogAuthorPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogAuthorForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add author - Feather CMS",
            description: "Add an author in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorAdd(
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
                .init(label: "Authors", link: "/admin/blog/authors/"),
                .init(label: "Add", link: "/admin/blog/authors/add/"),
            ]
        )
    }
}
