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

protocol AdminRemoveBlogPostInteractor: Sendable {

    func get(
        id: String
    ) async throws -> BlogPostDetailsModel

    func delete(
        id: String
    ) async throws
}
