import FeatherWebAdmin
import SystemModule

extension Permission.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            permission: SystemPermissionDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Permission.View.Error
        ) async throws -> HTMLResponse
    }
}
