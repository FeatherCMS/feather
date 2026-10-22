import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule


extension Variant.Add {
    struct Router {
        private let routes: Variant.Router.Routes
        let controller: any Variant.Add.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variant.Router.Routes
        ) {
            self.routes = routes
            self.controller = Variant.Add.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Variant.Add.Interactor.Default(
                            repository: Variant.Add.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Variant.Add.Presenter.Default(
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
