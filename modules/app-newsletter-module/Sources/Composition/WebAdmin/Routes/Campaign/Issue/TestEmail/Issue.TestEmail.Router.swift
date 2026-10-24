import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    struct Router {
        let controller: any Controller.Interface
        let routes: Campaign.Router.Routes

        init(environment: AppEnvironment, routes: Campaign.Router.Routes) {
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
                routes: routes
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            controller.route(on: router, routes: routes)
        }
    }
}
