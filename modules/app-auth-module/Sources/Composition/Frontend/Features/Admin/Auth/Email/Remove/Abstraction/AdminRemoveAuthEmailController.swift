import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

protocol AdminRemoveAuthEmailController: Sendable {

    func getRemoveAuthEmail(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthEmail(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthEmailController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthEmailRoutes.remove(RouterPath("{id}")),
            use: getRemoveAuthEmail
        )
        router.post(
            AuthEmailRoutes.remove(RouterPath("{id}")),
            use: postRemoveAuthEmail
        )
    }
}
