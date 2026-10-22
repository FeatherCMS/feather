import AuthAppAPI
import AuthModule
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
        Login.Router(
            repository: Login.Repository.OpenAPI(
                appClient: API.Client(environment: environment)
            ),
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
        )
        .controller.route(on: router)

        Logout.Router(
            repository: Logout.Repository.OpenAPI(
                environment: environment
            ),
            usesSecureCookies: usesSecureCookies
        )
        .controller.route(on: router)

        MagicLink.App
            .Router(
                environment: environment,
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier
            )
            .route(on: router)
    }

}
