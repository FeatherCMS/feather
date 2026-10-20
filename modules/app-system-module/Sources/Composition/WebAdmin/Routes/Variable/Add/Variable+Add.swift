import FeatherAdmin
import Hummingbird
import SystemModule

extension Variable {
    enum Add {}
}

extension Variable.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: Variable.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Variable.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    apiBaseURL: environment.apiBaseURL,
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
                use: controller.getAddSystemVariable
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddSystemVariable
            )
        }
    }
}
