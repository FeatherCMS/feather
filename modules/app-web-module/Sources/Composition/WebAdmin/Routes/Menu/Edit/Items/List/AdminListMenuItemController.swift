import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminListMenuItemController: Sendable {

    func getMenuItems(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postMenuItemMove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
