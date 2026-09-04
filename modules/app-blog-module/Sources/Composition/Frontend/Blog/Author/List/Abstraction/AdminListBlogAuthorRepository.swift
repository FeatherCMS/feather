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

protocol AdminListBlogAuthorRepository: Sendable {

    func listBlogAuthors(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorModel

    func delete(
        id: String
    ) async throws
}
