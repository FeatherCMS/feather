import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminAddBlogPostDefaultPresenter: AdminAddBlogPostPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: BlogPostForm.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Add post - Feather CMS",
            description: "Add a post in management",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostAdd(
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
                .init(label: "Posts", link: "/admin/blog/posts/"),
                .init(label: "Add", link: "/admin/blog/posts/add/"),
            ]
        )
    }
}
