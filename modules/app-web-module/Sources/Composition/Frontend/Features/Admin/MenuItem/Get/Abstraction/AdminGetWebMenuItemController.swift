import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebMenuItemController: Sendable {

    func getWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMenuItemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/",
            use: getWebMenuItem
        )
    }
}
