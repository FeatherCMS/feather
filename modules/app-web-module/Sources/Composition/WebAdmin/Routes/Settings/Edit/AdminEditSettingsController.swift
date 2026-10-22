import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminEditSettingsController: Sendable {
    func getEditSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditSettings(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
