import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminViewPageController: Sendable {

    func getPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}
