import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import WebComponents

extension Job.View.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Job.Router.Routes

        func renderDetailsPage(
            job: Job.View.Result
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Worker job details",
                content: Job.View.Page(
                    state: .init(job: job, routes: routes)
                )
            )
        }

        func renderErrorPage(
            error: Job.View.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "Worker job not found",
                    message: "This worker job may have been removed."
                )
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
                    title: "Worker job unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Worker job details",
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
            for error: Job.View.Error
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
