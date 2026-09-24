import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebMenuItemController: Sendable {

    func getWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebMenuItemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/",
            use: getWebMenuItem
        )
    }
}
