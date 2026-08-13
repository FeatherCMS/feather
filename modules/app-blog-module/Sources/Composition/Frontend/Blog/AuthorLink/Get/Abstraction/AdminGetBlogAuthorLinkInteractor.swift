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

protocol AdminGetBlogAuthorLinkInteractor: Sendable {

    func execute(
        entity: AdminGetBlogAuthorLinkModel
    ) async throws -> BlogAuthorLinkDetailsModel
}
