import Hummingbird

protocol AdminListMediaProcessorController: Sendable {

    func getListMediaProcessors(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func bulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func bulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/processors/",
            use: getListMediaProcessors
        )
        router.get(
            "/admin/media/processors/bulk-remove/",
            use: bulkRemoveConfirmation
        )
        router.post(
            "/admin/media/processors/bulk-remove/",
            use: bulkRemove
        )
    }
}
