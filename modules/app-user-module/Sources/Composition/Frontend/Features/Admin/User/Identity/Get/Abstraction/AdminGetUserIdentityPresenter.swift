import FeatherAdmin
import HTML
import Hummingbird

protocol AdminGetUserIdentityPresenter: Sendable {
    func renderDetailsPage(
        model: AdminGetUserIdentityModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminGetUserIdentityError) async throws
        -> HTMLResponse
}
