import SystemModule
import FeatherAdmin

protocol AdminViewSystemPermissionPresenter: Sendable {

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminViewSystemPermissionError
    ) async throws -> HTMLResponse
}
