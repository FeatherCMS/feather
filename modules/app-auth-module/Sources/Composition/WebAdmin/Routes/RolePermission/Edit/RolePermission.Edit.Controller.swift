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

extension RolePermission.Edit {
    enum Controller {}
}

extension RolePermission.Edit.Controller {
    protocol Interface: Sendable {

        func getAuthAccessControl(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAuthAccessControl(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}

extension RolePermission.Edit.Controller.Interface {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: RolePermission.Router.Routes
    ) {
        router.get(
            routes.edit.routerPath,
            use: getAuthAccessControl
        )
        router.post(
            routes.edit.routerPath,
            use: postAuthAccessControl
        )
    }
}
