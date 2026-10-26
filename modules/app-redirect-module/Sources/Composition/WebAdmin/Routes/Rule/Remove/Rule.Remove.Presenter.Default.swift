import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Rule.Router.Routes

        func renderErrorPage(error: Rule.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "Redirect rule not found",
                    message: "This redirect rule may have been removed."
                )
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to remove redirect rules."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot remove redirect rules."
                )
            case .conflict:
                state = .init(
                    title: "Unable to remove redirect rule",
                    message: "The redirect rule could not be removed."
                )
            case .unavailable:
                state = .init(
                    title: "Redirect rule unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove redirect rule",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
        }

        func renderSuccess(location: String, count: Int) -> Response {
            AdminNotification.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: count == 1
                        ? "Redirect rule removed successfully."
                        : "Redirect rules removed successfully."
                )
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot remove redirect rules.",
                status: .forbidden,
                cancel: routes.list.path
            )
        }
        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
        {
            try await renderStatusPage(
                title: "Confirmation expired",
                message:
                    "This confirmation is no longer valid. Please try again.",
                status: .badRequest,
                cancel: cancel
            )
        }

        private func renderStatusPage(
            title: String,
            message: String,
            status: HTTPResponse.Status,
            cancel: String
        ) async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove redirect rule",
                content: AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func status(for error: Rule.Remove.Error)
            -> HTTPResponse.Status
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
