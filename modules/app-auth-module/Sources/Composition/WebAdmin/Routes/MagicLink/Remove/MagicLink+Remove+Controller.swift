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

extension MagicLink.Remove {
    enum Controller {}
}

extension MagicLink.Remove.Controller {
    protocol Interface: Sendable {

        func postAuthMagicLinksRemove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
    }

    extension MagicLink.Remove.Controller.Interface {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: MagicLink.Router.Routes
    ) {
        router.post(routes.remove.routerPath, use: postAuthMagicLinksRemove)
    }
}
