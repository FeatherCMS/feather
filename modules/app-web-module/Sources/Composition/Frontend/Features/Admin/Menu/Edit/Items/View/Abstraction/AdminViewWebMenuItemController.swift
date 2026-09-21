import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebMenuItemController: Sendable {

    func getWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewWebMenuItemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/",
            use: getWebMenuItem
        )
    }
}
