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

protocol AdminAddBlogAuthorLinkInteractor: Sendable {

    func execute(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws
}
