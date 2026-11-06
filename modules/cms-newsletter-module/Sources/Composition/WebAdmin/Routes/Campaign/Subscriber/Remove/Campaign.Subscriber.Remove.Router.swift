import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Subscriber.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Campaign.Router.Routes

        init(environment: AppEnvironment, routes: Campaign.Router.Routes) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: ()
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(
                routes.subscriberRemove.routerPath,
                use: controller.post
            )
        }
    }
}
