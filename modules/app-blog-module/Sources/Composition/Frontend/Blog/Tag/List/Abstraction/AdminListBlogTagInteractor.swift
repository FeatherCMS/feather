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

protocol AdminListBlogTagInteractor: Sendable {

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel

}
