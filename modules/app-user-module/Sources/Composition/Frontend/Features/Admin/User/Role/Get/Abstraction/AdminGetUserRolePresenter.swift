import FeatherAdmin
import HTML
import Hummingbird

protocol AdminGetUserRolePresenter: Sendable {
    func renderDetailsPage(role: UserRoleDetailsModel, permissions: NewAdminListActions) async throws -> HTMLResponse
    func renderErrorPage(error: AdminGetUserRoleError) async throws -> HTMLResponse
}
