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

protocol AdminListBlogPostInteractor: Sendable {

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel

}
