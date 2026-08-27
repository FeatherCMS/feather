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

protocol AppLogoutAuthController: Sendable {

    func getLogout(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppLogoutAuthController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/logout/",
            use: getLogout
        )
    }
}
