import Hummingbird

protocol AdminGetWebMenuController: Sendable {

    func getWebMenu(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebMenuController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/menus/{id}/",
            use: getWebMenu
        )
    }
}
