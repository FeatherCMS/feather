import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Edit.Template {
    struct Router {
        private let controller: any Controller.Interface
        private let routes: Page.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            events: any EventPublisher,
            routes: Page.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            ),
                            events: events
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
            router.get(routes.template.routerPath, use: controller.get)
            router.post(routes.template.routerPath, use: controller.post)
        }
    }
}
