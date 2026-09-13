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
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(permissions)
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemVariableEditPage(
                form: SystemVariableEditForm(
                    state: state,
                    action: SystemVariableRoutes.edit(RouterPath(id))
                        .description,
                    viewHref: SystemVariableRoutes.details(RouterPath(id))
                        .description,
                    removeHref: actions.allows(
                        SystemPermissions.Variables.delete
                    ) ? NewAdminLocation.remove(
                        path: SystemVariableRoutes.remove.description,
                        ids: [id],
                        returnTo: SystemVariableRoutes.edit(RouterPath(id))
                            .description
                    ) : nil,
                    nonceToken: nonceToken
                )
            )
        )
    }

    func renderErrorPage(
        error: AdminEditSystemVariableError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State

        switch error {
        case .notFound:
            state = .init(
                title: "System variable not found",
                message: "This system variable may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot edit system variables."
            )
        case .conflict:
            state = .init(
                title: "Unable to save changes",
                message: "A system variable with this key already exists."
            )
        case .unavailable:
            state = .init(
                title: "System variable unavailable",
                message: "The request could not be completed. Please try again."
            )
        }

        return try await renderPage(
            content: NewAdminStatusView(
                state: state,
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

}
