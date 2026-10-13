import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminRemoveBlogPostPresenter: Sendable {

    func renderRemovePage(
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
