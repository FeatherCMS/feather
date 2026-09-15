import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserAdminAPI
import UserContracts
import WebComponents

struct AdminListUserIdentityDefaultPresenter: AdminListUserIdentityPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<Components.Schemas.UserIdentityListItemSchema>,
        permissions: Set<PermissionKey>,
        search: String?,
        role: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User identities",
            content: UserIdentityTable(
                permissions: NewAdminListActions(permissions),
                identities: model.items,
                pageState: model.pageState,
                search: search,
                role: role
            )
        )
    }

    func renderErrorPage(error: AdminListUserIdentityError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view user identities."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access user identities."
            )
        case .unavailable:
            state = .init(
                title: "User identities unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User identities",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminListUserIdentityError)
        -> HTTPResponse.Status
    {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
