import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.List {
    enum Presenter {}
}

extension WebAdmin.System.Job.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: WebAdmin.System.Job.List.Model,
            permissions: AdminListActions,
            search: String?,
            status: Int?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Job.List.Error
        ) async throws -> HTMLResponse
    }
}
