import AuthAdminAPI
import FeatherWebShared
import AuthAppAPI
import CSS
public import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
public import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents
public import WebFrontend

public enum AuthFrontendRoutes {

    public static func registerAppRoutes(
        router: Hummingbird.Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        authAPIBuilder: AuthAPIBuilder,
        usesSecureCookies: Bool,
        turnstileVerifier: (any TurnstileVerifier)? = nil
    ) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(
                appClient: authAPIBuilder.makeAuthApp()
            ),
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
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
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
        )
        .route(on: router)
    }

}
