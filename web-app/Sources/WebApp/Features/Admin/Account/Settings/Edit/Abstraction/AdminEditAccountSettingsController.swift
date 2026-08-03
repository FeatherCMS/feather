import Hummingbird

protocol AdminEditAccountSettingsController: Sendable {

    func getEditAccountSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAccountSettingsController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/account/settings/",
            use: getEditAccountSettings
        )
        router.post(
            "/admin/account/settings/",
            use: postEditAccountSettings
        )
    }
}
