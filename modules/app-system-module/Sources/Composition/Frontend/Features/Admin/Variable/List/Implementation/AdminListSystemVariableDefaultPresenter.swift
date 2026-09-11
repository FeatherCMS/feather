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
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        if let error {
            let layout = NewAdminBaseLayout(
                content: SystemVariableListError(
                    breadcrumb: systemVariableBreadcrumb(),
                    message: error
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

}

private struct SystemVariableListError: Component {
    let breadcrumb: NewAdminBreadcrumb.State
    let message: String

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            context.render(NewAdminStatusView(
                state: .init(
                    title: "Unable to load system variables.",
                    message: message
                ),
                icon: FeatherIcons.alertCircle()
            ))
        }
        .class("cms-section")
    }
}
