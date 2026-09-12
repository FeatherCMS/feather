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
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>
    ) async throws -> HTMLResponse {
        let actions = ListActions(permissions)
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemVariableEditPage(
                breadcrumb: breadcrumb(),
                form: SystemVariableEditForm(
                    state: state,
                    action: SystemVariableRoutes.edit(RouterPath(id))
                        .description,
                    submitLabel: "Save",
                    removeHref: actions.allows(
                        SystemPermissions.Variables.delete
                    ) ? SystemVariableRoutes.remove(id) : nil,
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    private func renderPage<T: Component>(content: T) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: content
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
