import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Subscriber.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: Subscriber.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Subscriber.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
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
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.details.routerPath, use: controller.view)
        }
    }
}
