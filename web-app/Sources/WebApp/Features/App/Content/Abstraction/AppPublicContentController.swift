import Hummingbird

protocol AppPublicContentController: Sendable {
    func getSingleSegment(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func getDoubleSegment(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppPublicContentController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/{segment}/{slug}/",
            use: getDoubleSegment
        )
        router.get(
            "/{segment}/",
            use: getSingleSegment
        )
    }
}
