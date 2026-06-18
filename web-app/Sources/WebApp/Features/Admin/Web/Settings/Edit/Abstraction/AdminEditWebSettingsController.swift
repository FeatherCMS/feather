import Hummingbird

protocol AdminEditWebSettingsController: Sendable {
    func getEditWebSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditWebSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditWebSettingsController {
    func route(
        on router: Router<AppRequestContext>
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
