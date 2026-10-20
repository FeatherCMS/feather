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

protocol AdminViewAuthOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAuthOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthAdminRoutes.auth,
            use: getOverview
        )
    }
}
