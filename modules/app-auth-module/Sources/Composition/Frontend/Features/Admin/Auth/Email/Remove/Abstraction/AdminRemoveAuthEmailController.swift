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
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthEmailController {

    func route(
        on router: Router<DefaultRequestContext>
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
