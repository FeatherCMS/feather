import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuItemController: Sendable {

    func getEditWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
