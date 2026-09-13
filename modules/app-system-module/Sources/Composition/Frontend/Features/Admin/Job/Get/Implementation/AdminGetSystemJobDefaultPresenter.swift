import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminGetSystemJobDefaultPresenter: AdminGetSystemJobPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        job: SystemJobDetailsModel
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Worker job details",
            content: SystemJobDetailsView(
                state: .init(job: job)
            )
        )
    }

    func renderErrorPage(
        error: AdminGetSystemJobError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
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
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Worker job details",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(
        for error: AdminGetSystemJobError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
