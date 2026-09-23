import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuItemController: Sendable {

    func getAddWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddWebMenuItemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/add/",
            use: getAddWebMenuItem
        )
        router.post(
            "/admin/web/menus/{id}/items/add/",
            use: postAddWebMenuItem
        )
    }
}
