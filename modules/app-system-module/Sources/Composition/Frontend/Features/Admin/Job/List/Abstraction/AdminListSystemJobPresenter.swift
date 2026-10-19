import SystemModule
import FeatherAdmin

protocol AdminListSystemJobPresenter: Sendable {
    func renderListPage(
        model: AdminListSystemJobModel,
        permissions: AdminListActions,
        search: String?,
        status: Int?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminListSystemJobError
    ) async throws -> HTMLResponse
}
