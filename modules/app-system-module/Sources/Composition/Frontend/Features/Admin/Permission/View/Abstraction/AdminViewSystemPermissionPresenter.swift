import FeatherAdmin
import Foundation

protocol AdminViewSystemPermissionPresenter: Sendable {

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminViewSystemPermissionError
    ) async throws -> HTMLResponse
}
