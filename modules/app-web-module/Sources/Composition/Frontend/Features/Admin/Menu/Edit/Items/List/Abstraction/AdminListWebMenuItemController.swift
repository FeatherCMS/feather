import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemController: Sendable {

    func getWebMenuItems(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getWebMenuItemsRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postWebMenuItemsRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postWebMenuItemMove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuItemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
