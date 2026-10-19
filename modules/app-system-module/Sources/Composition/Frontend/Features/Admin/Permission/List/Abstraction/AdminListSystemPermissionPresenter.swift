import SystemModule
import FeatherAdmin
import WebComponents

protocol AdminListSystemPermissionPresenter: Sendable {

    func renderListPage(
        model: AdminListSystemPermissionModel,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminListSystemPermissionError
    ) async throws -> HTMLResponse

}
