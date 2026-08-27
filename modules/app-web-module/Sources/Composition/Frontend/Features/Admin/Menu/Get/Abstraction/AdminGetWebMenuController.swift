import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebMenuController: Sendable {

    func getWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMenuController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/",
            use: getWebMenu
        )
    }
}
