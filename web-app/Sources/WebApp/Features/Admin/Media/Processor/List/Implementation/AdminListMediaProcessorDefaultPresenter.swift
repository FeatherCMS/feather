import AdminOpenAPI
import Hummingbird

struct AdminListMediaProcessorDefaultPresenter: AdminListMediaProcessorPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        items: [Components.Schemas.MediaProcessorListItemSchema],
        page: Int,
        pageSize: Int,
        total: Int,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminMedia.Scope.processors
        let canAccess = permissions.contains(scope.permission(for: .list))
        if error != nil {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Media processors - Feather CMS",
                description: "Media processors - Feather CMS",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: MediaProcessorErrorView(
                    info: "Unable to load media processors.",
                    breadcrumb: mediaProcessorsBreadcrumb()
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Media processors - Feather CMS",
            description: "Media processors - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaProcessorsListView(
                items: items,
                page: page,
                pageSize: pageSize,
                total: total,
                isAdded: isAdded,
                isEdited: isEdited,
                isRemoved: isRemoved,
                canAccess: canAccess,
                permissions: permissions,
                canAdd: permissions.contains(scope.create),
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your account cannot access media processors.",
                breadcrumb: mediaProcessorsBreadcrumb()
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
            title: "Remove selected processors",
            description: "Confirm bulk remove",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: mediaProcessorsBreadcrumb(),
                    title: "Remove selected processors",
                    message:
                        "Are you sure you want to remove these selected processors? This action cannot be undone.",
                    action: "/admin/media/processors/bulk-remove/",
                    cancelLink: ListBulkRemoveRedirect.location(
                        path: "/admin/media/processors/",
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

    private func mediaProcessorsBreadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Processors", link: "/admin/media/processors/"),
            ]
        )
    }
}
