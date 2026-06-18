import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminGetBlogAuthorDefaultPresenter: AdminGetBlogAuthorPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: BlogAuthorDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool,
        isAdded: Bool,
        isRemoved: Bool
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Blog author details - Feather CMS",
            description: "Management blog author details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorDetails(
                state: .init(
                    author: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions,
                    isPublished: isPublished,
                    isUnpublished: isUnpublished,
                    isAdded: isAdded,
                    isRemoved: isRemoved
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
            title: "Blog author details - Feather CMS",
            description: "Management blog author details",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorError(
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
            .init(label: "Authors", link: "/admin/blog/authors/"),
            .init(label: "Details", link: "/admin/blog/authors/\(id)/"),
        ])
    }
}
