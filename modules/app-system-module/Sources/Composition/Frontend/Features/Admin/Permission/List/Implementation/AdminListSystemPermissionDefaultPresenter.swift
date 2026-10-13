import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SystemContracts
import WebBuilders
import WebComponents

struct AdminListSystemPermissionDefaultPresenter:
    AdminListSystemPermissionPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: AdminListSystemPermissionModel,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Permissions",
            content: SystemPermissionTable(
                state: .init(
                    permissions: permissions,
                    permissionsList: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search
                )
            )
        )
    }

    func renderErrorPage(
        error: AdminListSystemPermissionError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view system permissions."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access system permissions."
            )
        case .unavailable:
            state = .init(
                title: "System permissions unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Permissions",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(
        for error: AdminListSystemPermissionError
    ) -> HTTPResponse.Status {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }

}
