import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuController: Sendable {

    func getAddWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus/add/",
            use: getAddWebMenu
        )
        router.post(
            "/admin/web/menus/add/",
            use: postAddWebMenu
        )
    }
}
