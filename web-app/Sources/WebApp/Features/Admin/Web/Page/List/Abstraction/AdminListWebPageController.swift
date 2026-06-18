import Hummingbird

protocol AdminListWebPageController: Sendable {

    func getWebPages(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getWebPagesBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postWebPagesBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postWebPageStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListWebPageController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/pages",
            use: getWebPages
        )
        router.get(
            "/admin/web/pages/bulk-remove/",
            use: getWebPagesBulkRemoveConfirmation
        )
        router.post(
            "/admin/web/pages/bulk-remove/",
            use: postWebPagesBulkRemove
        )
        router.post(
            "/admin/web/pages/{id}/status/",
            use: postWebPageStatus
        )
    }
}
