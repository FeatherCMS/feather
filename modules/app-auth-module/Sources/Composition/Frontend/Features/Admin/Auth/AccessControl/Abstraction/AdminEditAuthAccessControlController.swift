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
import WebStandards

protocol AdminEditAuthAccessControlController: Sendable {

    func getAuthAccessControl(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAuthAccessControl(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAuthAccessControlController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/access-control/",
            use: getAuthAccessControl
        )
        router.post(
            "/admin/auth/access-control/",
            use: postAuthAccessControl
        )
    }
}
