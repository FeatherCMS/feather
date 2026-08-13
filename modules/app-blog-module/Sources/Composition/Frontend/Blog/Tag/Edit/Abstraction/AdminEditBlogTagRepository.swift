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
import WebStandards

protocol AdminEditBlogTagRepository: Sendable {

    func load(
        id: String
    ) async throws -> BlogTagDetailsModel

    func update(
        id: String,
        input: BlogTagFormInput
    ) async throws
}
