import Foundation

protocol AdminGetSystemPermissionPresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderDetailsPage(
        permission: SystemPermissionDetailsModel,
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
