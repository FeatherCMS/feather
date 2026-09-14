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

protocol AdminListBlogAuthorLinkPresenter: Sendable {

    func renderListPage(
        menuId: String,
        model: AdminListBlogAuthorLinkModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
