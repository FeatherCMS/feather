import FeatherAdmin
import WebComponents

protocol AdminListSystemJobPresenter: Sendable {
    func renderListPage(
        model: AdminListSystemJobModel,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse
}
