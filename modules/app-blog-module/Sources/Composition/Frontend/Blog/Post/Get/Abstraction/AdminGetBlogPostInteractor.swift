import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminGetBlogPostInteractor: Sendable {

    func execute(
        entity: AdminGetBlogPostModel
    ) async throws -> BlogPostDetailsModel
}
