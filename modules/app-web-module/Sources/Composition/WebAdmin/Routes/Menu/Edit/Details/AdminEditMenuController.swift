import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditMenuController: Sendable {

    func getEditMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
