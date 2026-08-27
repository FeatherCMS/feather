import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebSettingsController: Sendable {
    func getEditWebSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditWebSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditWebSettingsController {
    func route(
        on router: Router<DefaultRequestContext>
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
