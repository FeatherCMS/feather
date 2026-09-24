import CSS
import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminViewStyle: Sendable {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/style.css",
            use: getStyle
        )
    }

    func getStyle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> CSSResponse {
        let designSystem = NewAdminDesignSystem()
        let stylesheet = Stylesheet(designSystem.rules())
        return CSSResponse(stylesheet)
    }
}
