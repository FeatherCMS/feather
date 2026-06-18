import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListWebMetadataDefaultPresenter:
    AdminListWebMetadataPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebMetadataModel,
        isEdited: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let scope = AdminWeb.Scope.metadata
        let canAccess = permissions.contains(scope.permission(for: .list))
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage metadata entries - Feather CMS",
                description: "Management web metadata list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: WebMetadataError(
                    state: .init(
                        info: "Unable to load metadata entries.",
                        message: error,
                        breadcrumb: webMetadataBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage metadata entries - Feather CMS",
            description: "Management web metadata list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: WebMetadataTable(
                state: .init(
                    isEdited: isEdited,
                    canAccess: canAccess,
                    permissions: permissions,
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access metadata entries.",
                    breadcrumb: webMetadataBreadcrumbState()
                )
            )
        )
    }

    private func webMetadataBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Metadata", link: "/admin/web/metadata/"),
            ]
        )
    }
}
