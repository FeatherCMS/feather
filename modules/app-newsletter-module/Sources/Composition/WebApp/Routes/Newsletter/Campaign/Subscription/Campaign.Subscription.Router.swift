import FeatherValidation
public import FeatherWebShared
import HTML
public import Hummingbird
public import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscription {
    public struct Router {
        private let controller: any Controller.Interface

        public static let defaultRoute = Route.standard

        public init(
            environment: AppEnvironment,
            route: Route = Router.defaultRoute,
            turnstileVerifier: (any TurnstileVerifier)? = nil
        ) {
            self.controller = Controller.Default(
                environment: environment,
                route: route,
                turnstileVerifier: turnstileVerifier
            )
        }

        public func route(
            on router: Hummingbird.Router<DefaultRequestContext>
        ) {
            router.post(
                controller.route.webRoute.routerPath,
                use: controller.subscribe
            )
        }
    }
}
