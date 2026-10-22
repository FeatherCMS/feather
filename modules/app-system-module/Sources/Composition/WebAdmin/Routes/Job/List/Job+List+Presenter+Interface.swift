import FeatherWebAdmin
import SystemModule

extension Job.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            model: Job.List.Model,
            permissions: AdminListActions,
            search: String?,
            status: Int?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Job.List.Error
        ) async throws -> HTMLResponse
    }
}
