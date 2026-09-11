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

protocol AdminAddBlogAuthorLinkRepository: Sendable {

    func create(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
