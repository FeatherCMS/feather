import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import MediaModule
import NewsModule

extension Category.Add {
    struct Router: Sendable {
        let controller: any Controller.Interface
        let routes: Category.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Category.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return Runtime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(api: api)
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            mediaRepository: MediaModule.Asset.File.View
                                .Repository.OpenAPI(api: api.mediaAdminAPI()),
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.add.routerPath, use: controller.getAddCategory)
            router.post(routes.add.routerPath, use: controller.postAddCategory)
        }
    }
}
