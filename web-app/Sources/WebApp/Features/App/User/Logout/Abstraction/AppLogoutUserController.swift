import Hummingbird

protocol AppLogoutUserController: Sendable {

    func getLogout(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppLogoutUserController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/logout/",
            use: getLogout
        )
    }
}
