import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditPageController: Sendable {

    func getEditPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
