import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuController: Sendable {

    func getEditWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditWebMenuController {

    func route(
        on router: Router<AppRequestContext>
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
