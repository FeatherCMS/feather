import Hummingbird

protocol AdminEditAuthProfileController: Sendable {

    func getEditAuthProfile(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthProfile(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAuthProfileController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/profile/edit/",
            use: getEditAuthProfile
        )
        router.post(
            "/admin/auth/profile/edit/",
            use: postEditAuthProfile
        )
    }
}
