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

protocol AdminEditBlogAuthorRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel

    func update(
        id: String,
        input: BlogAuthorFormInput
    ) async throws
}
