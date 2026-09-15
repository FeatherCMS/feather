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

protocol AdminEditBlogPostRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogPostDetailsModel

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws
}
