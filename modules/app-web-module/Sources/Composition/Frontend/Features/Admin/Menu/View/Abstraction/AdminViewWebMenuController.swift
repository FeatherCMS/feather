import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebMenuController: Sendable {

    func getWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebMenuController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/",
            use: getWebMenu
        )
    }
}
