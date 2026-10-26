import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Add {
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
            router.get(routes.add.routerPath, use: controller.get)
            router.post(routes.add.routerPath, use: controller.post)
        }
    }
}
