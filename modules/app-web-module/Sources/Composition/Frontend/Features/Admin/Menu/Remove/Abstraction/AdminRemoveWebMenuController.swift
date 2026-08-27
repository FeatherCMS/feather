import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuController: Sendable {

    func getRemoveWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebMenu(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuController {

    func route(
        on router: Router<DefaultRequestContext>
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
