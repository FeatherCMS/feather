import BlogAdminAPI
import BlogAppAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminListBlogAuthorLinkDefaultPresenter:
    AdminListBlogAuthorLinkPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        menuId: String,
        model: AdminListBlogAuthorLinkModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            BlogPermissions.AuthorLinks.list.rawValue
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage blog author links",
                description: "Management blog author link list",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: BlogAuthorLinkError(
                    state: .init(
                        info: "Unable to load blog author links.",
                        message: error,
                        breadcrumb: blogAuthorLinkBreadcrumbState(
                            menuId: menuId
                        )
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage blog author links",
            description: "Management blog author link list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogAuthorLinkTable(
                state: .init(
                    menuId: menuId,
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        BlogPermissions.AuthorLinks.create.rawValue
                    ),
                    items: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access blog author links.",
                    breadcrumb: blogAuthorLinkBreadcrumbState(menuId: menuId)
                )
            )
        )
    }

    func renderRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected links",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: blogAuthorLinkBreadcrumbState(menuId: menuId),
                    title: "Remove selected links",
                    message:
                        "Are you sure you want to remove these selected links? This action cannot be undone.",
                    action: "/admin/blog/authors/\(menuId)/links/remove/",
                    cancelLink: "/admin/blog/authors/\(menuId)/",
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func blogAuthorLinkBreadcrumbState(
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
            ]
        )
    }
}
