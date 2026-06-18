import Foundation
import Hummingbird

protocol AdminRemoveUserRolePresenter: Sendable {

    func renderRemovePage(
        id: String,
        name: String,
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
