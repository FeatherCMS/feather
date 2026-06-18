import Hummingbird

protocol AdminListWebMenuItemController: Sendable {

    func getWebMenuItems(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getWebMenuItemsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postWebMenuItemsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuItemController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/",
            use: getWebMenuItems
        )
        router.get(
            "/admin/web/menus/{id}/items/bulk-remove/",
            use: getWebMenuItemsBulkRemoveConfirmation
        )
        router.post(
            "/admin/web/menus/{id}/items/bulk-remove/",
            use: postWebMenuItemsBulkRemove
        )
    }
}
