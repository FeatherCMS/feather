import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebMenuPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>,
        isAdded: Bool,
        isRemoved: Bool
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
