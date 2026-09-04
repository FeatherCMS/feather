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

protocol AdminListBlogPostInteractor: Sendable {

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel

    func remove(
        ids: [String]
    ) async throws
}
