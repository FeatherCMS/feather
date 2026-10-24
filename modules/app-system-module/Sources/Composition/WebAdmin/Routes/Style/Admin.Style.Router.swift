import CSS
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import WebComponents

extension Admin {
    enum Style {}
}

extension Admin.Style {
    struct Router: Sendable {
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
}
