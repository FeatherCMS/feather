import Hummingbird

protocol AppGetStylesheetController: Sendable {

    func getStyleCSS(
        request: Request,
        context: AppRequestContext
    ) async throws -> CSSResponse
}

extension AppGetStylesheetController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/style.css",
            use: getStyleCSS
        )
    }
}
