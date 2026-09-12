import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    private var requestNotification: AdminNotification? {
        AdminNotificationFlash.notification(from: request)
    }

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        let actions = ListActions(permissions)
        return renderPage(
            content: SystemVariableTable(
                state: .init(
                    permissions: actions,
                    variables: model.items,
                    pageState: model.pageState,
                    search: search,
                    breadcrumb: systemVariableBreadcrumb()
                )
            ),
            menuGroups: menuGroups,
            notification: requestNotification
        )
    }

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        return renderPage(
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            ),
            menuGroups: menuGroups,
            notification: requestNotification
        )
    }

    private func renderPage<T: Component>(
        content: T,
        menuGroups: [NewAdminSidebar.Group],
        notification: AdminNotification?
    ) -> HTMLResponse {
        var renderContext = RenderContext()
        let layout = NewAdminBaseLayout(
            content: content,
            menuGroups: menuGroups,
            notification: notification
        )
        return .init(
            renderContext.render(
                NewAdminHTML(
                    title: "Variables",
                    body: .init(content: layout)
                )
            )
        )
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
