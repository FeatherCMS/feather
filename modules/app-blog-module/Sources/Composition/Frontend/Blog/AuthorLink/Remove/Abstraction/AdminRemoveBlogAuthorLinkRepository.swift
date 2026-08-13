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
