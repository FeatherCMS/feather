import FeatherAdmin
import Foundation

protocol AdminGetSystemPermissionPresenter: Sendable {

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse
}
