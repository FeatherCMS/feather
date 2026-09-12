import FeatherAdmin
import WebComponents

protocol AdminListSystemPermissionPresenter: Sendable {

    func renderListPage(
        model: AdminListSystemPermissionModel,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse

}
