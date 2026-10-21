import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct Router {
    private let renderingEngine: any RenderingEngine
    private let environment: AppEnvironment
    private let usesSecureCookies: Bool
    private let turnstileVerifier: (any AuthTurnstileVerifier)?

    public init(
        renderingEngine: any RenderingEngine,
        environment: AppEnvironment,
        usesSecureCookies: Bool,
        turnstileVerifier: (any AuthTurnstileVerifier)? = nil
    ) {
        self.renderingEngine = renderingEngine
        self.environment = environment
        self.usesSecureCookies = usesSecureCookies
        self.turnstileVerifier = turnstileVerifier
    }

    public func route(on router: Hummingbird.Router<DefaultRequestContext>) {
        AppLoginAuth(
            repository: AppLoginAuthOpenAPIRepository(
                appClient: API.Client(environment: environment)
            ),
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
        )
        .controller.route(on: router)

        AppLogoutAuth(
            repository: AppLogoutAuthOpenAPIRepository(
                environment: environment
            ),
            usesSecureCookies: usesSecureCookies
        )
        .controller.route(on: router)

        AppMagicLink(
            environment: environment,
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
        )
        .route(on: router)
    }

}
