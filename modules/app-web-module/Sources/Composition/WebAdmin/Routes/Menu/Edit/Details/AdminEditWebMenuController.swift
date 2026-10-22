import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuController: Sendable {

    func getEditWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
