import Hummingbird

protocol AdminEditBlogSettingsController: Sendable {
    func getEditBlogSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogSettings(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditBlogSettingsController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/settings/",
            use: getEditBlogSettings
        )
        router.post(
            "/admin/blog/settings/",
            use: postEditBlogSettings
        )
    }
}
