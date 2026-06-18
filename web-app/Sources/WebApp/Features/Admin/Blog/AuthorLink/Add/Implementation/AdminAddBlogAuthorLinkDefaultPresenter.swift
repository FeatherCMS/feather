import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddBlogAuthorLinkDefaultPresenter: AdminAddBlogAuthorLinkPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        menuId: String,
        state: BlogAuthorLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add blog author link - Feather CMS",
            description: "Add a blog author link in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkAdd(
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
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Authors", link: "/admin/blog/authors/"),
                .init(label: "Author", link: "/admin/blog/authors/\(menuId)/"),
                .init(
                    label: "Links",
                    link: "/admin/blog/authors/\(menuId)/links/"
                ),
                .init(
                    label: "Add",
                    link: "/admin/blog/authors/\(menuId)/links/add/"
                ),
            ]
        )
    }
}
