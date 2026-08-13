import FeatherAdmin
import Hummingbird

protocol AdminEditSettingsController: Sendable {

    func getEditSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditSettingsController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/account/settings/",
            use: getEditSettings
        )
        router.post(
            "/admin/account/settings/",
            use: postEditSettings
        )
    }
}
