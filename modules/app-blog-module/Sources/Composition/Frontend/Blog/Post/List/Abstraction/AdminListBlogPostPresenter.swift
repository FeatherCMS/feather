import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminListBlogPostPresenter: Sendable {

    func renderListPage(
        model: AdminListBlogPostModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemovePage(
        page: Int,
        search: String?,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse
}
