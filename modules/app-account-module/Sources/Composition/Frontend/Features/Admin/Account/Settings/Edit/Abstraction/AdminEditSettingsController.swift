import FeatherAdmin
import Hummingbird

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

extension AdminEditSettingsController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.settings.description + "/"),
            use: getEditSettings
        )
        router.post(
            RouterPath(AccountAdminRoutes.settings.description + "/"),
            use: postEditSettings
        )
        router.get(
            RouterPath(
                AccountAdminRoutes.userSettingsPattern.description + "/"
            ),
            use: getEditSettings
        )
        router.post(
            RouterPath(
                AccountAdminRoutes.userSettingsPattern.description + "/"
            ),
            use: postEditSettings
        )
    }
}
