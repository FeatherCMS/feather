import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Edit {
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
                routes: routes,
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(api: api),
                            optionRepository: Post.Add.OptionRepository.OpenAPI(
                                api: api
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
            let route = routes.posts
                .appending(parameter: "id")
                .appending(pathComponent: "edit")
                .routerPath
            router.get(route, use: controller.get)
            router.post(route, use: controller.post)
        }
    }
}
