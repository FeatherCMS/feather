import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuController: Sendable {

    func getRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
