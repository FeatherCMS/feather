import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>?,
        notification: AdminNotification?,
        permissions: Set<String>,
        search: String?,
        error: String?,
        accessDenied: Bool
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        if accessDenied {
            let layout = NewAdminBaseLayout(
                content: NewAdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot access system variables."
                    ),
                    icon: FeatherIcons.alertCircle()
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
        if let error {
            let layout = NewAdminBaseLayout(
                content: NewAdminStatusView(
                    state: .init(
                        title: "Unable to load system variables.",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
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
        let layout = NewAdminBaseLayout(
            content: SystemVariableTable(
                state: .init(
                    permissions: Set(permissions.map(PermissionKey.init)),
                    variables: model?.items ?? [],
                    pageState: model?.pageState
                        ?? .init(
                            page: 1,
                            pageSize: AdminListSystemVariable.pageSize,
                            total: 0
                        ),
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
                .init(label: "System", link: "/admin/system/"),
            ]
        )
    }

}
