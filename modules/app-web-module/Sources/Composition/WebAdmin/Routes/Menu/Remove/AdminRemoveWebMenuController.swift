import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebMenuController: Sendable {

    func postRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveWebMenuController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post("/admin/web/menus/remove/", use: postRemoveWebMenu)
    }
}
