import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Article.List {
    struct Router: Sendable {
        let controller: any Controller.Interface
        let routes: Article.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Article.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return Runtime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
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

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.list.routerPath, use: controller.getArticles)
        }
    }
}
