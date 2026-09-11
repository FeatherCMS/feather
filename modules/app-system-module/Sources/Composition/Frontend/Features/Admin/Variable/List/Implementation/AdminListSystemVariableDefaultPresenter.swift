import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import SystemContracts
import WebComponents

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        permissions: Set<String>,
        search: String?
    ) async throws -> HTMLResponse {
        var renderContext = RenderContext()
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let notification = AdminNotificationFlash.notification(from: request)
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

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(request: request, events: events)
        let notification = AdminNotificationFlash.notification(from: request)
        var renderContext = RenderContext()
        let layout = NewAdminBaseLayout(
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            ),
            menuGroups: menuGroups,
            notification: notification
        )
        return .init(renderContext.render(NewAdminHTML(
            title: "Manage system variables",
            body: .init(content: layout)
        )))
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
