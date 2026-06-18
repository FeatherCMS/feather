import HTML
import Hummingbird

protocol AdminRemoveWebMenuController: Sendable {

    func getRemoveWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/remove/",
            use: getRemoveWebMenu
        )
        router.post(
            "/admin/web/menus/{id}/remove/",
            use: postRemoveWebMenu
        )
    }
}
