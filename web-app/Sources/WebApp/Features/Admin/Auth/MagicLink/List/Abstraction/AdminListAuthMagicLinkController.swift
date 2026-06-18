import Hummingbird

protocol AdminListAuthMagicLinkController: Sendable {

    func getAuthMagicLinks(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getAuthMagicLinksBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postAuthMagicLinksBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links",
            use: getAuthMagicLinks
        )
        router.get(
            "/admin/auth/magic-links/bulk-remove/",
            use: getAuthMagicLinksBulkRemoveConfirmation
        )
        router.post(
            "/admin/auth/magic-links/bulk-remove/",
            use: postAuthMagicLinksBulkRemove
        )
    }
}
