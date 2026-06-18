import Hummingbird

protocol AdminGetMediaProcessorController: Sendable {

    func getMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/processors/{id}/",
            use: getMediaProcessor
        )
    }
}
