import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPageController: Sendable {

    func getWebPages(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postWebPageStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
