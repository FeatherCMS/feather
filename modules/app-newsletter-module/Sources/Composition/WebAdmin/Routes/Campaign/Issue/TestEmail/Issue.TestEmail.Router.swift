import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    struct Router {
        let controller: any Controller.Interface
        let routes: Campaign.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Campaign.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                repository: { context in
                    Repository.OpenAPI(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                },
                routes: routes,
                renderingEngine: renderingEngine
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.issueTestEmail.routerPath, use: controller.get)
            router.post(routes.issueTestEmail.routerPath, use: controller.send)
            router.get(
                routes.issueDetailTestEmail.routerPath,
                use: controller.get
            )
            router.post(
                routes.issueDetailTestEmail.routerPath,
                use: controller.send
            )
        }
    }
}
