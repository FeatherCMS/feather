import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: MenuItem.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: MenuItem.Router.Routes
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(
                routes.itemRemove.routerPath,
                use: controller.getRemoveMenuItem
            )
            router.post(
                routes.itemRemove.routerPath,
                use: controller.postRemoveMenuItem
            )
            router.post(
                routes.itemsRemove.routerPath,
                use: controller.postRemoveMenuItem
            )
        }
    }
}
