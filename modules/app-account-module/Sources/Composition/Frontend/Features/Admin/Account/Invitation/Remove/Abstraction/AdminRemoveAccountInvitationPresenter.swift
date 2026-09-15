import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminRemoveAccountInvitationPresenter: Sendable {

    func renderRemovePage(
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
