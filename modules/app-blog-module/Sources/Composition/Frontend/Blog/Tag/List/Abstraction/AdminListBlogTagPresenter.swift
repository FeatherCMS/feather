import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminListBlogTagPresenter: Sendable {

    func renderListPage(
        model: AdminListBlogTagModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse
}
