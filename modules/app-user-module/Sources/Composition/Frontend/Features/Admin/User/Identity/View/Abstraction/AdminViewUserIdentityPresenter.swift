import FeatherAdmin
import HTML
import Hummingbird

protocol AdminViewUserIdentityPresenter: Sendable {
    func renderDetailsPage(
        model: AdminViewUserIdentityModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminViewUserIdentityError) async throws
        -> HTMLResponse
}
