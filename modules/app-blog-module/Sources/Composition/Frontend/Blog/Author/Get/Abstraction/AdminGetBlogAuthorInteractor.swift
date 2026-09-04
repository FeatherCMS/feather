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

protocol AdminGetBlogAuthorInteractor: Sendable {

    func execute(
        entity: AdminGetBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel
}
