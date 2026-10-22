import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuItemController: Sendable {

    func getAddWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
