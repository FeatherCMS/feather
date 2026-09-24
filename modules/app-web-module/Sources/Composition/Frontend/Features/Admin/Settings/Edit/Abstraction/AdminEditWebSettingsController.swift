import FeatherAdmin
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

extension AdminEditWebSettingsController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/settings/",
            use: getEditWebSettings
        )
        router.post(
            "/admin/web/settings/",
            use: postEditWebSettings
        )
    }
}
