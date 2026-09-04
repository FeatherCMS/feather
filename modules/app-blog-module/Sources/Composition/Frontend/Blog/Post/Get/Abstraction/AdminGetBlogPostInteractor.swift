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
import WebFrontend
import WebComponents
import WebBuilders

protocol AdminGetBlogPostInteractor: Sendable {

    func execute(
        entity: AdminGetBlogPostModel
    ) async throws -> BlogPostDetailsModel
}
