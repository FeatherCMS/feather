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
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminGetBlogAuthorPresenter: Sendable {

    func renderDetailsPage(
        rule: BlogAuthorDetailsModel,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>,
        isPublished: Bool,
        isUnpublished: Bool,
        isAdded: Bool,
        isRemoved: Bool
    ) -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
