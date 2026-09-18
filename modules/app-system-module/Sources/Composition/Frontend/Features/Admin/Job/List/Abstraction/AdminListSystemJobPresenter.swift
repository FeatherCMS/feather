import FeatherAdmin
import WebComponents

protocol AdminListSystemJobPresenter: Sendable {
    func renderListPage(
        model: AdminListSystemJobModel,
        permissions: NewAdminListActions,
        search: String?,
        status: Int?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminListSystemJobError
    ) async throws -> HTMLResponse
}
