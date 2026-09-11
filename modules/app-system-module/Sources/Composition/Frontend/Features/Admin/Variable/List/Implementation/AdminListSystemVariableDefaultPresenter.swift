import SystemAdminAPI
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
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        notification: AdminNotification?,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
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
                        breadcrumb: legacySystemVariableBreadcrumbState()
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
                    permissions: Set(permissions.map(PermissionKey.init)),
                    variables: model.items,
                    pageState: model.pageState,
                    search: search ?? "",
                    breadcrumb: systemVariableBreadcrumb()
                )
            ),
            menuGroups: menuGroups,
            notification: notification
        )
        let component = NewAdminHTML(
            title: "Manage system variables",
            body: .init(content: layout)
        )
        return .init(renderContext.render(component))
    }

    private func systemVariableBreadcrumb() -> NewAdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "System", link: "/admin/system/")]
        )
    }

    private func legacySystemVariableBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: systemVariableBreadcrumb().links.map {
                .init(label: $0.label, link: $0.link)
            }
        )
    }
}
