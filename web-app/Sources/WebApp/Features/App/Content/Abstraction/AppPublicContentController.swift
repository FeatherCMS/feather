import Hummingbird

protocol AppPublicContentController: Sendable {

    func getContent(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppPublicContentController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/**",
            use: getContent
        )
    }
}
