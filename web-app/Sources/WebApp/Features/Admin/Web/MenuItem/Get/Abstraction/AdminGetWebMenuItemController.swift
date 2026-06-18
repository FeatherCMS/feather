import Hummingbird

protocol AdminGetWebMenuItemController: Sendable {

    func getWebMenuItem(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMenuItemController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/items/{itemId}/",
            use: getWebMenuItem
        )
    }
}
