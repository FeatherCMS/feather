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

protocol AdminListBlogTagPresenter: Sendable {

    func renderListPage(
        model: AdminListBlogTagModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
