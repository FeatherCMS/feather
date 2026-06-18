import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveBlogTagDefaultPresenter:
    AdminRemoveBlogTagPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        id: String,
        source: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove tag - Feather CMS",
            description: "Remove confirmation for a management tag",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagConfirmation(
                state: .init(
                    id: id,
                    source: source,
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
            title: "Remove tag - Feather CMS",
            description: "Remove confirmation for a management tag",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagError(
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
                .init(label: "Tags", link: "/admin/blog/tags/"),
                .init(
                    label: "Remove",
                    link: "/admin/blog/tags/\(id)/remove/"
                ),
            ]
        )
    }
}
