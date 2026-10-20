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

protocol AdminRemoveBlogPostInteractor: Sendable {

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel

    func delete(
        id: String
    ) async throws

    func delete(ids: [String]) async throws
}
