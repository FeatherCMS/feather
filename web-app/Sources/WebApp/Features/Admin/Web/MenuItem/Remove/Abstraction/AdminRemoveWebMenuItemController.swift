import HTML
import Hummingbird

protocol AdminRemoveWebMenuItemController: Sendable {

    func getRemoveWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuItemController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/remove/",
            use: getRemoveWebMenuItem
        )
        router.post(
            "/admin/web/menus/{id}/items/{itemId}/remove/",
            use: postRemoveWebMenuItem
        )
    }
}
