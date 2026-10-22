import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebPageController: Sendable {

    func getWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}
