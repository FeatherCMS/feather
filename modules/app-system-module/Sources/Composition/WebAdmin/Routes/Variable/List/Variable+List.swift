import FeatherAdmin
import Hummingbird
import SystemModule

extension Variable {
    enum List {}
}

extension Variable.List {
    struct Router {
        static let pageSize = 20

        let controller: any Controller.Interface
        let routes: Variable.Router.Routes

        init(
            apiBuilder: API.Builder,
            renderingEngine: any RenderingEngine,
            routes: Variable.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeSystemAdmin(context)
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
                routes.list.routerPath,
                use: controller.getSystemVariables
            )
        }
    }
}
