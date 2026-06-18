import Hummingbird

protocol AdminGetAuthProfileController: Sendable {

    func getAuthProfile(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAuthProfileController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/profile/",
            use: getAuthProfile
        )
    }
}
