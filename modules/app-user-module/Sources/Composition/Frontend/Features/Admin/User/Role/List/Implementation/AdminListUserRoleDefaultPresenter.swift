import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserAdminAPI

struct AdminListUserRoleDefaultPresenter: AdminListUserRolePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<Components.Schemas.UserRoleListItemSchema>,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User roles",
            content: UserRoleTable(
                permissions: NewAdminListActions(permissions),
                roles: model.items,
                pageState: model.pageState,
                search: search
            )
        )
    }

    func renderErrorPage(error: AdminListUserRoleError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view user roles."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access user roles."
            )
        case .unavailable:
            state = .init(
                title: "User roles unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User roles",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminListUserRoleError)
        -> HTTPResponse.Status
    {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
