import FeatherAdmin
import Hummingbird
import SystemModule

extension Job.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Job.Router.Routes

        func renderListPage(
            model: Job.List.Model,
            permissions: AdminListActions,
            search: String?,
            status: Int?
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Worker jobs",
                content: SystemJobTable(
                    state: .init(
                        jobs: model.items,
                        permissions: permissions,
                        pageState: model.pageState,
                        search: search,
                        status: status,
                        routes: routes
                    )
                )
            )
        }

        func renderErrorPage(
            error: Job.List.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            switch error {
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to view worker jobs."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot access worker jobs."
                )
            case .unavailable:
                state = .init(
                    title: "Worker jobs unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Worker jobs",
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
            for error: Job.List.Error
        ) -> HTTPResponse.Status {
            switch error {
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
