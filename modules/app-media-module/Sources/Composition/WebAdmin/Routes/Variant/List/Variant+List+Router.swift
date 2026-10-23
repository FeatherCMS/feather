import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule



extension Variant.List {
    struct Router {
        static let pageSize = 20
        private let routes: Variant.Router.Routes
        let controller: any Variant.List.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variant.Router.Routes
        ) {
            self.routes = routes
            self.controller = Variant.List.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Variant.List.Interactor.Default(
                            repository: Variant.List.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Variant.List.Presenter.Default(
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
                routes.list.routerPath,
                use: controller.getMediaVariants
            )
        }
    }
}
