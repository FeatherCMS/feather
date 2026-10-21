import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuItemController: Sendable {

    func postRemoveWebMenuItem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuItemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            "/admin/web/menus/{id}/items/remove/",
            use: postRemoveWebMenuItem
        )
    }
}
