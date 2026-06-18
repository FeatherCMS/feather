import HTML
import Hummingbird

protocol AdminAddWebMenuController: Sendable {

    func getAddWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddWebMenuController {

    func route(
        on router: Router<AppRequestContext>
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
