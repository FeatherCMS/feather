import CSS
import FeatherAdmin
import Hummingbird
import SystemModule
import WebComponents

struct AdminViewStyle: Sendable {
    let path: WebRoute

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            path.routerPath,
            use: getStyle
        )
    }

    func getStyle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> CSSResponse {
        let designSystem = AdminDesignSystem()
        let stylesheet = Stylesheet(designSystem.rules())
        return CSSResponse(stylesheet)
    }
}
