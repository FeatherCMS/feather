import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuController: Sendable {

    func getWebMenus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getWebMenusRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebMenusRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListWebMenuController {

    func route(
        on router: Router<DefaultRequestContext>
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
