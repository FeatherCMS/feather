import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebMenuController: Sendable {

    func getWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/",
            use: getWebMenu
        )
    }
}
