import HTML
import Hummingbird

protocol AdminEditWebMenuItemController: Sendable {

    func getEditWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditWebMenuItemController {

    func route(
        on router: Router<AppRequestContext>
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
