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

protocol AdminEditBlogAuthorLinkInteractor: Sendable {

    func load(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func update(
        menuId: String,
        id: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
