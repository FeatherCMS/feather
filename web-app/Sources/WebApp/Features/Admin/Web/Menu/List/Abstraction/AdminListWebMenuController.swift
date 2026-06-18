import Hummingbird

protocol AdminListWebMenuController: Sendable {

    func getWebMenus(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getWebMenusBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postWebMenusBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus",
            use: getWebMenus
        )
        router.get(
            "/admin/web/menus/bulk-remove/",
            use: getWebMenusBulkRemoveConfirmation
        )
        router.post(
            "/admin/web/menus/bulk-remove/",
            use: postWebMenusBulkRemove
        )
    }
}
