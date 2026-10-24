import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule
import WebComponents

extension Identity.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Identity.Router.Routes

        func renderDetailsPage(
            model: Identity.Detail.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User identity details",
                content: Identity.Detail.Details(
                    routes: routes,
                    identity: model,
                    permissions: permissions
                )
            )
        }

        func renderErrorPage(error: Identity.Detail.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
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
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User identity details",
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

        private func status(for error: Identity.Detail.Error)
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
}
