import Hummingbird

protocol AdminGetAuthMagicLinkController: Sendable {

    func getAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/",
            use: getAuthMagicLink
        )
    }
}
