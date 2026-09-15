import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebMetadataPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMetadataDetailsModel,
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
