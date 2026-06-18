import Hummingbird

protocol AppLoginUserController: Sendable {

    func getLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppLoginUserController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/login/",
            use: getLogin
        )
        router.post(
            "/login/",
            use: postLogin
        )
    }
}
