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

protocol AdminAddAuthEmailController: Sendable {

    func getAddAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddAuthEmailController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/emails/add/",
            use: getAddAuthEmail
        )
        router.post(
            "/admin/auth/emails/add/",
            use: postAddAuthEmail
        )
    }
}
