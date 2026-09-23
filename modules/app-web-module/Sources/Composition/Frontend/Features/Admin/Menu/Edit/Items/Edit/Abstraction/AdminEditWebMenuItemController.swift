import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminEditWebMenuItemController: Sendable {

    func getEditWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditWebMenuItemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
