import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminRemoveAccountInvitationPresenter: Sendable {

    func renderRemovePage(
        id: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
