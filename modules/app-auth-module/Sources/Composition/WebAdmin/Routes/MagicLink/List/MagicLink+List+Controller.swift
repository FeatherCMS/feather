import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

extension MagicLink.List {
    enum Controller {}
}

extension MagicLink.List.Controller {
    protocol Interface: Sendable {

        func getAuthMagicLinks(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
    }

    extension MagicLink.List.Controller.Interface {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: MagicLink.Router.Routes
    ) {
        router.get(
            routes.list.routerPath,
            use: getAuthMagicLinks
        )
    }
}
