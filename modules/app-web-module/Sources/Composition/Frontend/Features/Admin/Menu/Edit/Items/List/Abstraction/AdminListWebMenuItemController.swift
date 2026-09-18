import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemController: Sendable {

    func getWebMenuItems(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getWebMenuItemsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebMenuItemsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebMenuItemMove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuItemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/",
            use: getWebMenuItems
        )
        router.get(
            "/admin/web/menus/{id}/items/remove/",
            use: getWebMenuItemsRemoveConfirmation
        )
        router.post(
            "/admin/web/menus/{id}/items/remove/",
            use: postWebMenuItemsRemove
        )
        router.post(
            "/admin/web/menus/{id}/items/{itemId}/move/",
            use: postWebMenuItemMove
        )
    }
}
