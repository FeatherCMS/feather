import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddPageController: Sendable {

    func getAddPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
