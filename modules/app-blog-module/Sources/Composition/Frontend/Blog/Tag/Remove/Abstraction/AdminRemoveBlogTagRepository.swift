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

protocol AdminRemoveBlogTagRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel

    func delete(
        id: String
    ) async throws
}
