import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddMenuItemController: Sendable {

    func getAddMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
