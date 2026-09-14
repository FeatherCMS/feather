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
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminViewBlogAuthorInteractor: Sendable {

    func execute(
        entity: AdminViewBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel
}
