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

        AppAcceptAccountInvitation(
            renderingEngine: renderingEngine
        ).route(on: router)
        AppMagicLink(renderingEngine: renderingEngine).route(on: router)
    }

    public static func registerAdminRoutes(
        router: Router<AppRequestContext>,
        renderingEngine: any RenderingEngine
    ) {
        AdminAuth(renderingEngine: renderingEngine).route(on: router)
        AdminListAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
        AdminRemoveAuthSession(renderingEngine: renderingEngine)
            .controller
            .route(on: router)
    }
}
