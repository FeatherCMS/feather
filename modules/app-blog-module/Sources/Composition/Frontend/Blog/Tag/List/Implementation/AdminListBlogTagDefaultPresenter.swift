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
import WebStandards

struct AdminListBlogTagDefaultPresenter:
    AdminListBlogTagPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListBlogTagModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPublished: Bool,
        isUnpublished: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(BlogPermissions.Tags.list.rawValue)
        let canEdit = permissions.contains(BlogPermissions.Tags.update.rawValue)
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage blog tags - Feather CMS",
                description: "Management blog tag list",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: BlogTagError(
                    state: .init(
                        info: "Unable to load blog tags.",
                        message: error,
                        breadcrumb: blogTagBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage blog tags - Feather CMS",
            description: "Management blog tag list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: BlogTagTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    isPublished: isPublished,
                    isUnpublished: isUnpublished,
                    canAccess: canAccess,
                    canEdit: canEdit,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        BlogPermissions.Tags.create.rawValue
                    ),
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access blog tags.",
                    breadcrumb: blogTagBreadcrumbState()
                )
            )
        )
    }

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected pages",
            description: "Confirm bulk remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: blogTagBreadcrumbState(),
                    title: "Remove selected pages",
                    message:
                        "Are you sure you want to remove these selected pages? This action cannot be undone.",
                    action: "/admin/blog/tags/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/blog/tags/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    ),
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func blogTagBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Blog", link: "/admin/blog/"),
                .init(label: "Tags", link: "/admin/blog/tags/"),
            ]
        )
    }
}
