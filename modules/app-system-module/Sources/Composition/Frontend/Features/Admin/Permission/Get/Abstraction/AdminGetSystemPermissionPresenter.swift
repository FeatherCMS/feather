import FeatherAdmin
import Foundation

protocol AdminGetSystemPermissionPresenter: Sendable {

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminGetSystemPermissionError
    ) async throws -> HTMLResponse
}
