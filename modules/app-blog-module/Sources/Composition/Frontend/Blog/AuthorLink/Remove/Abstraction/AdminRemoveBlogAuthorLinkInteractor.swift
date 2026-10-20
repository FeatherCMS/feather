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

protocol AdminRemoveBlogAuthorLinkInteractor: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws

    func delete(
        menuId: String,
        ids: [String]
    ) async throws
}
