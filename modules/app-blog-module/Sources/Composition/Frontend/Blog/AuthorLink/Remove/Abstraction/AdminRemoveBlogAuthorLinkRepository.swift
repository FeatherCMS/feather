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

protocol AdminRemoveBlogAuthorLinkRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
