import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminListBlogAuthorLinkRepository: Sendable {

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
