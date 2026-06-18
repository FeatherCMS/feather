import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveBlogAuthorLinkDefaultPresenter:
    AdminRemoveBlogAuthorLinkPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        menuId: String,
        id: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove blog author link - Feather CMS",
            description:
                "Remove confirmation for a management blog author link",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkConfirmation(
                state: .init(
                    menuId: menuId,
                    id: id,
                    label: label,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
                )
            )
        )
    }

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove blog author link - Feather CMS",
            description:
                "Remove confirmation for a management blog author link",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(menuId: menuId, id: id)
                )
            )
        )
    }

    func breadcrumb(
        menuId: String,
        id: String
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
                    label: "Remove",
                    link: "/admin/blog/authors/\(menuId)/links/\(id)/remove/"
                ),
            ]
        )
    }
}
