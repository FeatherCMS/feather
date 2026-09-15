import FeatherAdmin
import WebComponents

protocol AdminListSystemPermissionPresenter: Sendable {

    func renderListPage(
        model: AdminListSystemPermissionModel,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminListSystemPermissionError
    ) async throws -> HTMLResponse

}
