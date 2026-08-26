import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminAddWebMenuController: Sendable {

    func getAddWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddWebMenuController {

    func route(
        on router: Router<DefaultRequestContext>
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
