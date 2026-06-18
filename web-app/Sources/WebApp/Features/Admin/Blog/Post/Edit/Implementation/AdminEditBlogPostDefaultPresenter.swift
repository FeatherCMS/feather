import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminEditBlogPostDefaultPresenter: AdminEditBlogPostPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: BlogPostForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit post - Feather CMS",
            description: "Edit a management post",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit post - Feather CMS",
            description: "Edit a management post",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Posts", link: "/admin/blog/posts/"),
                .init(
                    label: "Edit",
                    link: "/admin/blog/posts/\(id)/edit/"
                ),
            ]
        )
    }
}
