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

public enum AuthFrontendRoutes {
    public enum Scope {
        public static let magicLinks = PermissionScope(
            module: "auth",
            resource: "magic-links"
        )
        public static let profile = PermissionScope(
            module: "auth",
            resource: "profile"
        )
        public static let accessControl = PermissionScope(
            module: "auth",
            resource: "access-control"
        )
        public static let credentials = PermissionScope(
            module: "auth",
            resource: "credential"
        )
    }

    public static func registerAppRoutes(
        router: Router<AppRequestContext>,
        renderingEngine: any RenderingEngine,
        authAppClient: AuthAppAPIClient
    ) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(appClient: authAppClient),
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AppLogoutAuth(
            repository: AppLogoutAuthOpenAPIRepository(appClient: authAppClient)
        )
        .controller.route(on: router)
    }

    public static func registerAdminRoutes(
        router: Router<AppRequestContext>,
        renderingEngine: any RenderingEngine
    ) {
        AdminAuth(renderingEngine: renderingEngine).route(on: router)
        AdminRemoveAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
    }
}
