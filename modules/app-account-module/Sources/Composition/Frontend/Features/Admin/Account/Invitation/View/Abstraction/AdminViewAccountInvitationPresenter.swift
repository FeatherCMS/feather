import FeatherAdmin
import Foundation

protocol AdminViewAccountInvitationPresenter: Sendable {

    func renderDetailsPage(
        invitation: AccountInvitationDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
