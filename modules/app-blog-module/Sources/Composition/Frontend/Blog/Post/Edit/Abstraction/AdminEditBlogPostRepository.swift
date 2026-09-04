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

protocol AdminEditBlogPostRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogPostDetailsModel

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws
}
