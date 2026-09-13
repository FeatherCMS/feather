import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminViewUserIdentityDefaultPresenter: AdminViewUserIdentityPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        model: AdminViewUserIdentityModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User identity details",
            content: UserIdentityDetails(
                identity: model,
                permissions: permissions
            )
        )
    }

    func renderErrorPage(error: AdminViewUserIdentityError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "User identity not found",
                message: "This user identity may have been removed."
            )
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
                title: "User identity unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User identity details",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminViewUserIdentityError)
        -> HTTPResponse.Status
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
