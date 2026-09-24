import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuController: Sendable {

    func getEditWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/edit/",
            use: getEditWebMenu
        )
        router.post(
            "/admin/web/menus/{id}/edit/",
            use: postEditWebMenu
        )
    }
}
