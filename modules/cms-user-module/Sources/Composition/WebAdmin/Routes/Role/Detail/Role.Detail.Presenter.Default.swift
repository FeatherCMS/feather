import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Role.Router.Routes

        func renderDetailsPage(
            role: Role.Detail.Repository.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User role details",
                content: Role.Detail.Details(
                    routes: routes,
                    role: role,
                    permissions: permissions
                )
            )
        }

        func renderErrorPage(error: Role.Detail.Error) async throws
            -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "User role not found",
                    message: "This user role may have been removed."
                )
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view user roles."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access user roles."
                )
            case .unavailable:
                state = .init(
                    title: "User role unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User role details",
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

        private func status(for error: Role.Detail.Error)
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
