import Hummingbird

protocol AdminAddAuthMagicLinkController: Sendable {

    func getAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/add/",
            use: getAddAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/add/",
            use: postAddAuthMagicLink
        )
    }
}
