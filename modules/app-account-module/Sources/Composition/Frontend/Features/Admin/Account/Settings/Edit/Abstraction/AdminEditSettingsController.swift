import FeatherAdmin
import Hummingbird

protocol AdminEditSettingsController: Sendable {

    func getEditSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditSettings(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditSettingsController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/settings/",
            use: getEditSettings
        )
        router.post(
            "/admin/account/settings/",
            use: postEditSettings
        )
        router.get(
            "/admin/account/users/{userId}/settings/",
            use: getEditSettings
        )
        router.post(
            "/admin/account/users/{userId}/settings/",
            use: postEditSettings
        )
    }
}
