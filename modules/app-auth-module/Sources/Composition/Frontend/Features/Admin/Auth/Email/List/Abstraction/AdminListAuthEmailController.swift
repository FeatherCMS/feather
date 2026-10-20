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
import SystemModuleWebAdmin
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

protocol AdminListAuthEmailController: Sendable {

    func getAuthEmails(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListAuthEmailController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthEmailRoutes.list,
            use: getAuthEmails
        )
    }
}
