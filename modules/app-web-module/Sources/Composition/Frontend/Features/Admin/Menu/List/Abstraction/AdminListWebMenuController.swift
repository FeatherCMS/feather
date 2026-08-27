import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuController: Sendable {

    func getWebMenus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getWebMenusBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebMenusBulkRemove(
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
            "/admin/web/menus/bulk-remove/",
            use: getWebMenusBulkRemoveConfirmation
        )
        router.post(
            "/admin/web/menus/bulk-remove/",
            use: postWebMenusBulkRemove
        )
    }
}
