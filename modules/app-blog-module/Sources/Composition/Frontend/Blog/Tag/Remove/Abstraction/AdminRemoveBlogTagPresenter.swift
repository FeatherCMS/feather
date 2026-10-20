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

protocol AdminRemoveBlogTagPresenter: Sendable {

    func renderRemovePage(
        item: AdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
