import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuController: Sendable {

    func getAddWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
