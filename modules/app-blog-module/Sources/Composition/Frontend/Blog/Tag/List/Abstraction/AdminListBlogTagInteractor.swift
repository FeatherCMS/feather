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

protocol AdminListBlogTagInteractor: Sendable {

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel

    func remove(
        ids: [String]
    ) async throws
}
