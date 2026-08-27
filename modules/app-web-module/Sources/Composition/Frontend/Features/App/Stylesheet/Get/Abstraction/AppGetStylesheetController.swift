import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AppGetStylesheetController: Sendable {

    func getStyleCSS(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> CSSResponse
}

extension AppGetStylesheetController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/style.css",
            use: getStyleCSS
        )
    }
}
