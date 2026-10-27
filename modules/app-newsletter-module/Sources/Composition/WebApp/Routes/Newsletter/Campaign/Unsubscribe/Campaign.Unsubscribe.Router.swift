public import FeatherWebApp
public import FeatherWebShared
public import Hummingbird
public import NewsletterModule

extension Campaign.Unsubscribe {
    public struct Router {
        private let controller: any Controller.Interface

        public init(
            environment: AppEnvironment,
            templateRenderer: any TemplateRenderer,
            route: Route = .standard
        ) {
            self.controller = Controller.Default(
                environment: environment,
                templateRenderer: templateRenderer,
                route: route
            )
        }

        public func route(
            on router: any RouterMethods<DefaultRequestContext>
        ) {
            router.get(
                controller.route.confirmation.routerPath,
                use: controller.getConfirmation
            )
            router.post(
                controller.route.confirmation.routerPath,
                use: controller.postOneClick
            )
            router.post(
                controller.route.confirmationAction.routerPath,
                use: controller.postConfirmation
            )
        }
    }
}
