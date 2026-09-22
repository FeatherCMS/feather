import FeatherAdmin
import Hummingbird
import RedirectAdminAPI

struct AdminListRedirectRuleDefaultPresenter: AdminListRedirectRulePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: NewAdminListModel<Components.Schemas.RedirectRuleListItemSchema>,
        permissions: NewAdminListActions,
        search: String?,
        statusCode: String?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Redirect rules",
            content: RedirectRuleTable(
                state: .init(
                    permissions: permissions,
                    rules: model.items,
                    pageState: model.pageState,
                    search: search,
                    statusCode: statusCode
                )
            )
        )
    }

    func renderErrorPage(error: AdminListRedirectRuleError) async throws
        -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
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
                title: "Redirect rules unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Redirect rules",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(for error: AdminListRedirectRuleError)
        -> HTTPResponse.Status
    {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
