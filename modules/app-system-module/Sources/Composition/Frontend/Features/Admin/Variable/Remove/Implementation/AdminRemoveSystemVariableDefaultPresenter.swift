import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebComponents

struct AdminRemoveSystemVariableDefaultPresenter:
    AdminRemoveSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        return render(
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            ),
            menuGroups: menuGroups
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        fromDetails: Bool
    ) async throws -> HTMLResponse {
        let menuGroups = try await context.adminMenuGroups(
            request: request,
            events: events
        )
        return render(
            content: NewAdminConfirmation(
                breadcrumb: breadcrumb(),
                title: "Remove selected variables",
                message:
                    "You’re about to permanently remove the selected system variables. This action cannot be undone.",
                selectedIDs: ids,
                selectedNames: names,
                action: SystemVariableRoutes.remove.description,
                cancel: fromDetails && ids.count == 1
                    ? SystemVariableRoutes.details(RouterPath(ids[0])).description
                    : ids.count == 1
                    ? SystemVariableRoutes.edit(RouterPath(ids[0])).description
                    : ListRemoveRedirect.location(
                        path: SystemVariableRoutes.list.description,
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    ),
                hiddenFields: ids.map {
                    .init(name: "ids", value: $0)
                }
            ),
            menuGroups: menuGroups
        )
    }

    private func render<T: Component>(
        content: T,
        menuGroups: [NewAdminSidebar.Group]
    ) -> HTMLResponse {
        var context = RenderContext()
        let layout = NewAdminBaseLayout(
            content: content,
            menuGroups: menuGroups
        )
        return .init(
            context.render(
                NewAdminHTML(
                    title: "Manage system variables",
                    body: .init(content: layout)
                )
            )
        )
    }

    private func breadcrumb() -> NewAdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(
                label: "Variables",
                link: SystemVariableRoutes.list.description
            ),
        ])
    }
}
