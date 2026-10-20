import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.View {
    enum Presenter {}
}

extension WebAdmin.System.Permission.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            permission: SystemPermissionDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Permission.View.Error
        ) async throws -> HTMLResponse
    }
}
