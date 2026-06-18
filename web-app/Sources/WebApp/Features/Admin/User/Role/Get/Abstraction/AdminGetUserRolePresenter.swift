import Foundation
import HTML

protocol AdminGetUserRolePresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderDetailsPage(
        role: UserRoleDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse
}
