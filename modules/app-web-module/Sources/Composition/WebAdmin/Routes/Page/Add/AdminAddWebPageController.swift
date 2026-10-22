import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebPageController: Sendable {

    func getAddWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
