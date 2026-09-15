import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebPagePresenter: Sendable {

    func renderDetailsPage(
        rule: WebPageDetailsModel,
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
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
