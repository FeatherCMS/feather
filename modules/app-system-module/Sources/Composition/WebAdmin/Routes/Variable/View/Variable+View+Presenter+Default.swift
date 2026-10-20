import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Variable.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variable.Router.Routes

        func renderDetailsPage(
            variable: SystemVariableDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "System variable details",
                content: SystemVariableDetails(
                    state: .init(
                        variable: variable,
                        permissions: permissions,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            error: Variable.View.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State

            switch error {
            case .notFound:
                state = .init(
                    title: "System variable not found",
                    message: "This system variable may have been removed."
                )
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view system variables."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access system variables."
                )
            case .unavailable:
                state = .init(
                    title: "System variable unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }

            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "System variable details",
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
            for error: Variable.View.Error
        ) -> HTTPResponse.Status {
            switch error {
            case .notFound:
                .notFound
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .unavailable:
                .serviceUnavailable
            }
        }

    }
}
