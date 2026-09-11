import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemContracts
import WebComponents
import WebBuilders

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListSystemVariableModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
        let canAccess = permissions.contains(
            SystemPermissions.Variables.list.rawValue
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage system variables",
                description: "Management system variable list",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: SystemVariableError(
                    state: .init(
                        info: "Unable to load system variables.",
                        message: error,
                        breadcrumb: systemVariableBreadcrumbState()
                    )
                )
            )
        }
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let layout = NewAdminBaseLayout(
            content: SystemVariableTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        SystemPermissions.Variables.create.rawValue
                    ),
                    variables: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access system variables.",
                    breadcrumb: systemVariableBreadcrumb()
                )
            ),
            menuGroups: menuGroups
        )
        let component = NewAdminHTML(
            title: "Manage system variables",
            body: .init(content: layout)
        )
        return .init(renderContext.render(component))
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected variables",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: systemVariableBreadcrumbState(),
                    title: "Remove selected variables",
                    message:
                        "Are you sure you want to remove these selected variables? This action cannot be undone.",
                    action: "/admin/system/variables/remove/",
                    cancelLink: ListRemoveRedirect.location(
                        path: "/admin/system/variables/",
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

    private func systemVariableBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "System", link: "/admin/system/"),
                .init(label: "Variables", link: "/admin/system/variables/"),
            ]
        )
    }

    private func systemVariableBreadcrumb() -> NewAdminBreadcrumb {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "System", link: "/admin/system/"),
                .init(label: "Variables", link: "/admin/system/variables/")
            ]
        )
    }
}
