import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Add {
    struct Router {
        private let routes: Variant.Router.Routes
        let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variant.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
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
            router.get(
                routes.add.routerPath,
                use: controller.getAddMediaVariant
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddMediaVariant
            )
        }
    }
}
