import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuController: Sendable {

    func getWebMenus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getWebMenusRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postWebMenusRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/web/menus",
            use: getWebMenus
        )
        router.get(
            "/admin/web/menus/remove/",
            use: getWebMenusRemoveConfirmation
        )
        router.post(
            "/admin/web/menus/remove/",
            use: postWebMenusRemove
        )
    }
}
