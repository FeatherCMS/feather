import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminListSystemVariableDefaultPresenter:
    AdminListSystemVariablePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<
            Components.Schemas.SystemVariableListItemSchema
        >,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(permissions)
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Variables",
            content: SystemVariableTable(
                state: .init(
                    permissions: actions,
                    variables: model.items,
                    pageState: model.pageState,
                    search: search,
                )
            ),

        )
    }

    func renderErrorPage(
        error: AdminListSystemVariableError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State

        switch error {
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view system variables."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access system variables."
            )
        case .unavailable:
            state = .init(
                title: "System variables unavailable",
                message: "The request could not be completed. Please try again."
            )
        }

        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Variables",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(
        for error: AdminListSystemVariableError
    ) -> HTTPResponse.Status {
        switch error {
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .unavailable:
            .serviceUnavailable
        }
    }

}
