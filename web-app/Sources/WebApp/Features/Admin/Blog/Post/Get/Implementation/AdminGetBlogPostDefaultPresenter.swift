import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetBlogPostDefaultPresenter: AdminGetBlogPostPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogPostDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog post details - Feather CMS",
            description: "Management blog post details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostDetails(
                state: .init(
                    rule: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions,
                    isPublished: isPublished,
                    isUnpublished: isUnpublished
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog post details - Feather CMS",
            description: "Management blog post details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogPostError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Blog", link: "/admin/blog/"),
            .init(label: "Posts", link: "/admin/blog/posts/"),
            .init(label: "Details", link: "/admin/blog/posts/\(id)/"),
        ])
    }
}
