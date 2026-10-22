import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminViewMenuController: Sendable {

    func getMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}
