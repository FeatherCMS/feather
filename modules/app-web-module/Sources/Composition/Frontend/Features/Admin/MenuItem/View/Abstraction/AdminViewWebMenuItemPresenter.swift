import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebMenuItemPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMenuItemDetailsModel,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        menuId: String,
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
