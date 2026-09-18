import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminListSystemJobDefaultPresenter: AdminListSystemJobPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderListPage(
        model: AdminListSystemJobModel,
        permissions: NewAdminListActions,
        search: String?,
        status: Int?
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Worker jobs",
            content: SystemJobTable(
                state: .init(
                    jobs: model.items,
                    permissions: permissions,
                    pageState: model.pageState,
                    search: search,
                    status: status
                )
            )
        )
    }

    func renderErrorPage(
        error: AdminListSystemJobError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
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
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Worker jobs",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(
        for error: AdminListSystemJobError
    ) -> HTTPResponse.Status {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
