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

protocol AdminGetAuthHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAuthHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/",
            use: getHome
        )
    }
}
