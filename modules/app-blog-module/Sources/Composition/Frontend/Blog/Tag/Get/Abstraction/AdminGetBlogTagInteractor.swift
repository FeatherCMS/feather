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

protocol AdminGetBlogTagInteractor: Sendable {

    func execute(
        entity: AdminGetBlogTagModel
    ) async throws -> BlogTagDetailsModel
}
