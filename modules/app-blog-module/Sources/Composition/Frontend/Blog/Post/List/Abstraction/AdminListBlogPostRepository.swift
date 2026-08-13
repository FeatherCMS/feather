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
import WebStandards

protocol AdminListBlogPostRepository: Sendable {

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel

    func delete(
        id: String
    ) async throws
}
