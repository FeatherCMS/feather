import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminViewMenuItemController: Sendable {

    func getMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}
