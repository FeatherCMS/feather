import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebSettingsController: Sendable {
    func getEditWebSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
