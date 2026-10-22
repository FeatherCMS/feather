import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddMenuController: Sendable {

    func getAddMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
