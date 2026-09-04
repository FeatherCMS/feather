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

protocol AdminListBlogAuthorLinkInteractor: Sendable {

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel

    func remove(
        menuId: String,
        ids: [String]
    ) async throws
}
