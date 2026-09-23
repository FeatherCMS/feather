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
        authAPIBuilder: AuthAPIBuilder,
        usesSecureCookies: Bool
    ) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(
                appClient: authAPIBuilder.makeAuthApp()
            ),
            usesSecureCookies: usesSecureCookies
        )
        .controller.route(on: router)

        AppLogoutAuth(
            repository: AppLogoutAuthOpenAPIRepository(
                appClient: authAPIBuilder.makeAuthApp()
            ),
            usesSecureCookies: usesSecureCookies
        )
        .controller.route(on: router)

        AppMagicLink(
            apiBuilder: authAPIBuilder,
            usesSecureCookies: usesSecureCookies
        ).route(on: router)
    }

}
