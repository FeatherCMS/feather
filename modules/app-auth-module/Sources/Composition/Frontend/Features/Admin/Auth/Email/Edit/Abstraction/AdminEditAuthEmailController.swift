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

protocol AdminEditAuthEmailController: Sendable {

    func getEditAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAuthEmailController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AuthEmailRoutes.edit(RouterPath("{id}")),
            use: getEditAuthEmail
        )
        router.post(
            AuthEmailRoutes.edit(RouterPath("{id}")),
            use: postEditAuthEmail
        )
    }
}
