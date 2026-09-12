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
        search: String?
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
                    search: search
                )
            )
        )
    }

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Worker jobs",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
