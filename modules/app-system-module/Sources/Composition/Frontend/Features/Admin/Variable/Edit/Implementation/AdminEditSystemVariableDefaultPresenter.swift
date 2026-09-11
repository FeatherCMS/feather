import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import SystemContracts
import WebComponents

struct AdminEditSystemVariableDefaultPresenter:
    AdminEditSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher

    func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>
    ) async throws -> HTMLResponse {
        let actions = ListActions(permissions)
        return try await renderPage(
            content: SystemVariableEditPage(
                breadcrumb: breadcrumb(),
                form: SystemVariableEditForm(
                    state: state,
                    action: SystemVariableRoutes.edit(RouterPath(id)).description,
                    submitLabel: "Save changes",
                    removeHref: actions.allows(SystemPermissions.Variables.delete) ? SystemVariableRoutes.remove(id) : nil
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        return try await renderPage(
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    private func renderPage<T: Component>(content: T) async throws -> HTMLResponse {
        try await SystemVariableAdminPageRenderer(
            request: request,
            context: context,
            events: events
        ).render(content: content)
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
