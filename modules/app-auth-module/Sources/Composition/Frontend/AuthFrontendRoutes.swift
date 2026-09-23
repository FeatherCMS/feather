import AuthAdminAPI
import AuthAppAPI
import CSS
public import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
public import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

public enum AuthFrontendRoutes {

    public static func registerAppRoutes(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        authAppClient: AuthAppAPIClient
    ) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(appClient: authAppClient)
        )
        .controller.route(on: router)

        AppLogoutAuth(
            repository: AppLogoutAuthOpenAPIRepository(appClient: authAppClient)
        )
        .controller.route(on: router)

        AppMagicLink(renderingEngine: renderingEngine).route(on: router)
    }

}
