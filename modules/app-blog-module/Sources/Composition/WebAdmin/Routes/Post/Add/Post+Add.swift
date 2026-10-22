import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: Post.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Post.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                environment: environment,
                routes: routes,
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(api: api),
                            optionRepository: OptionRepository.OpenAPI(api: api)
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
            router.get(routes.postAddRoute.routerPath, use: controller.get)
            router.post(routes.postAddRoute.routerPath, use: controller.post)
        }
    }
}
