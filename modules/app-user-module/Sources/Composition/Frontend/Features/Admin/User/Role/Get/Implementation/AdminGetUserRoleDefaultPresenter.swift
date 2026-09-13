import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminGetUserRoleDefaultPresenter: AdminGetUserRolePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(role: UserRoleDetailsModel, permissions: NewAdminListActions) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User role details",
            content: UserRoleDetails(role: role, permissions: permissions)
        )
    }

    func renderErrorPage(error: AdminGetUserRoleError) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound: state = .init(title: "User role not found", message: "This user role may have been removed.")
        case .unauthorized: state = .init(title: "Session expired", message: "Please sign in again to view user roles.")
        case .forbidden: state = .init(title: "Forbidden", message: "Your account cannot access user roles.")
        case .unavailable: state = .init(title: "User role unavailable", message: "The request could not be completed. Please try again.")
        }
        let page = try await renderingEngine.renderNewAdminPage(request: request, context: context, title: "User role details", content: NewAdminStatusView(state: state, icon: FeatherIcons.alertCircle()))
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminGetUserRoleError) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
