import Hummingbird

protocol AdminAddMediaProcessorController: Sendable {

    func getAddMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaProcessor(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddMediaProcessorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/media/processors/add/",
            use: getAddMediaProcessor
        )
        router.post(
            "/admin/media/processors/add/",
            use: postAddMediaProcessor
        )
    }
}
