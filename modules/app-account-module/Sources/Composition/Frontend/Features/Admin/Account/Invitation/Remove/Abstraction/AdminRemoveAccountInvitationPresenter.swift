import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminRemoveAccountInvitationPresenter: Sendable {

    func renderRemovePage(
        id: String,
        email: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
