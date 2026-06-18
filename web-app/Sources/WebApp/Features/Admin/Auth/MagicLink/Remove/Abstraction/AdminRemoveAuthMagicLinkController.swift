import Hummingbird

protocol AdminRemoveAuthMagicLinkController: Sendable {

    func getRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/remove/",
            use: getRemoveAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/{id}/remove/",
            use: postRemoveAuthMagicLink
        )
    }
}
