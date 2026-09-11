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
        ids: [String]
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
                    "Are you sure you want to remove these selected variables? This action cannot be undone.",
                selectedIDs: ids,
                action: SystemVariableRoutes.removeRoute.description,
                cancel: ListRemoveRedirect.location(
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
