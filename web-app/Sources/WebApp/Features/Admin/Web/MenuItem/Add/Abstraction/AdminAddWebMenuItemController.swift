import HTML
import Hummingbird

protocol AdminAddWebMenuItemController: Sendable {

    func getAddWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddWebMenuItemController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/add/",
            use: getAddWebMenuItem
        )
        router.post(
            "/admin/web/menus/{id}/items/add/",
            use: postAddWebMenuItem
        )
    }
}
