import Hummingbird

protocol AdminEditAuthMagicLinkController: Sendable {

    func getEditAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/edit/",
            use: getEditAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/{id}/edit/",
            use: postEditAuthMagicLink
        )
    }
}
