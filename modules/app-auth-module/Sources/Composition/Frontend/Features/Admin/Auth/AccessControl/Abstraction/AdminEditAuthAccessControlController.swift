import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

protocol AdminEditAuthAccessControlController: Sendable {

    func getAuthAccessControl(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAuthAccessControl(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditAuthAccessControlController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthAccessControlRoutes.accessControl,
            use: getAuthAccessControl
        )
        router.post(
            AuthAccessControlRoutes.accessControl,
            use: postAuthAccessControl
        )
    }
}
