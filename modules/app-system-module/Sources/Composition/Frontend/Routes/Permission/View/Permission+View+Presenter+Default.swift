import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import SystemModule
import WebComponents

extension WebAdmin.System.Permission.View.Presenter {
    struct Default:
        WebAdmin.System.Permission.View.Presenter.Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: WebAdmin.System.Permission.Router.Routes

        func renderDetailsPage(
            permission: SystemPermissionDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "System permission details",
                content: SystemPermissionDetailsView(
                    state: .init(
                        permission: permission,
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            error: WebAdmin.System.Permission.View.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "System permission not found",
                    message: "This system permission may have been removed."
                )
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
                    title: "System permission unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "System permission details",
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

        private func status(
            for error: WebAdmin.System.Permission.View.Error
        ) -> HTTPResponse.Status {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
