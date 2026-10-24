import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Category.List {
    struct Router: Sendable {
        let controller: any Category.List.Controller.Interface
        let routes: Category.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Category.Router.Routes
        ) {
            self.routes = routes
            self.controller = Category.List.Controller.Default(
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return Category.List.Runtime(
                        interactor: Category.List.Interactor.Default(
                            repository: Category.List.Repository.OpenAPI(
                                api: api
                            )
                        ),
                        presenter: Category.List.Presenter.Default(
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
            router.get(routes.list.routerPath, use: controller.getCategories)
        }
    }
}
