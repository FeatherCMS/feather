import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuController: Sendable {

    func getWebMenus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus",
            use: getWebMenus
        )
    }
}
