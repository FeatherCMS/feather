import Hummingbird

protocol AdminEditAuthSettingsController: Sendable {

    func getEditAuthSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAuthSettingsController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/settings/",
            use: getEditAuthSettings
        )
        router.post(
            "/admin/auth/settings/",
            use: postEditAuthSettings
        )
    }
}
