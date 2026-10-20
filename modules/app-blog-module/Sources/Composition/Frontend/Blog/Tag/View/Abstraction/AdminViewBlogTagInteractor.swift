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

protocol AdminViewBlogTagInteractor: Sendable {

    func execute(
        entity: AdminViewBlogTagModel
    ) async throws -> BlogTagDetailsModel
}
