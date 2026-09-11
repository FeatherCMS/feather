import FeatherAdmin
import Hummingbird
import WebComponents
import CSS

struct AdminGetStyle: Sendable {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/style.css",
            use: getStyle
        )
    }

    func getStyle(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> CSSResponse {
        let designSystem = NewAdminDesignSystem()
        let stylesheet = Stylesheet(designSystem.rules())
        return CSSResponse(stylesheet)
    }
}
