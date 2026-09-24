import FeatherAdmin
import Hummingbird

struct AdminViewRedirectRuleDefaultPresenter: AdminViewRedirectRulePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: RedirectRuleDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Redirect rule details",
            content: RedirectRuleDetails(rule: rule, permissions: permissions)
        )
    }

    func renderErrorPage(error: AdminViewRedirectRuleError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "Redirect rule not found",
                message: "This redirect rule may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view redirect rules."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access redirect rules."
            )
        case .unavailable:
            state = .init(
                title: "Redirect rule unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Redirect rule details",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminViewRedirectRuleError)
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
