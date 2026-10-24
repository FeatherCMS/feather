import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectAdminAPI
import RedirectApplication
import RedirectModule

extension Rule.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Rule.Router.Routes

        func renderListPage(
            model: AdminListModel<
                Components.Schemas.RedirectRuleQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?,
            statusCode: String?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Redirect rules",
                content: Rule.List.Page(
                    state: .init(
                        permissions: permissions,
                        rules: model.items,
                        pageState: model.pageState,
                        search: search,
                        statusCode: statusCode,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(error: Rule.List.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
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
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Redirect rules",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
        }

        private func status(for error: Rule.List.Error)
            -> HTTPResponse.Status
        {
            switch error {
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
