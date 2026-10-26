import AuthAppAPI
import AuthModule
public import FeatherWebApp
public import FeatherWebShared
public import Hummingbird

public struct Router {
    private let templateRenderer: any TemplateRenderer
    private let environment: AppEnvironment
    private let usesSecureCookies: Bool
    private let turnstileVerifier: (any AuthTurnstileVerifier)?

    public init(
        templateRenderer: any TemplateRenderer,
        environment: AppEnvironment,
        usesSecureCookies: Bool,
        turnstileVerifier: (any AuthTurnstileVerifier)? = nil
    ) {
        self.templateRenderer = templateRenderer
        self.environment = environment
        self.usesSecureCookies = usesSecureCookies
        self.turnstileVerifier = turnstileVerifier
    }

    public func route(on router: Hummingbird.Router<DefaultRequestContext>) {
        Login.Router(
            repository: Login.Repository.OpenAPI(
                appClient: API.Client(environment: environment)
            ),
            templateRenderer: templateRenderer,
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier
        )
        .route(on: router)

        Logout.Router(
            repository: Logout.Repository.OpenAPI(
                environment: environment
            ),
            usesSecureCookies: usesSecureCookies
        )
        .route(on: router)

        MagicLink.App
            .Router(
                environment: environment,
                templateRenderer: templateRenderer,
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier
            )
            .route(on: router)
    }

}
