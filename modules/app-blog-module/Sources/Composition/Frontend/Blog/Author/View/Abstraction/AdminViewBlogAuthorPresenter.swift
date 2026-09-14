import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminViewBlogAuthorPresenter: Sendable {

    func renderDetailsPage(
        rule: BlogAuthorDetailsModel,
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
