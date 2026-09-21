import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuItemController: Sendable {

    func getEditWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenuItem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditWebMenuItemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/edit/",
            use: getEditWebMenuItem
        )
        router.post(
            "/admin/web/menus/{id}/items/{itemId}/edit/",
            use: postEditWebMenuItem
        )
    }
}
