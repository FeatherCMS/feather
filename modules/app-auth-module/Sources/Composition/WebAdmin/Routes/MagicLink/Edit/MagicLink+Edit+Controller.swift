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

extension MagicLink.Edit.Controller {
    protocol Interface: Sendable {

        func getEditAuthMagicLink(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditAuthMagicLink(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}

extension MagicLink.Edit.Controller.Interface {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: MagicLink.Router.Routes
    ) {
        router.get(
            routes.edit.routerPath,
            use: getEditAuthMagicLink
        )
        router.post(
            routes.edit.routerPath,
            use: postEditAuthMagicLink
        )
    }
}
