import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditMenuItemController: Sendable {

    func getEditMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
