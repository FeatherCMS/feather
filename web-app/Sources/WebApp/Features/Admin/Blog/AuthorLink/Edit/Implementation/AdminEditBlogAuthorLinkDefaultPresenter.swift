import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminEditBlogAuthorLinkDefaultPresenter: AdminEditBlogAuthorLinkPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        menuId: String,
        id: String,
        state: BlogAuthorLinkForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit blog author link - Feather CMS",
            description: "Edit a management blog author link",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkEdit(
                state: .init(
                    menuId: menuId,
                    id: id,
                    isEdited: isEdited,
                    form: state,
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
            title: "Edit blog author link - Feather CMS",
            description: "Edit a management blog author link",
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
                    label: "Edit",
                    link: "/admin/blog/authors/\(menuId)/links/\(id)/edit/"
                ),
            ]
        )
    }
}
