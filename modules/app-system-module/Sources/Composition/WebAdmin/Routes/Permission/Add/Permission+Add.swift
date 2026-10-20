import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission {
    enum Add {}
}

extension Permission.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: Permission.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Permission.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    let repository = Repository.OpenAPI(
                        api: API.Client(
                            apiBaseURL: environment.apiBaseURL,
                            requestContext: context
                        )
                    )
                    let interactor = Interactor.Default(repository: repository)
                    let presenter = Presenter.Default(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine,
                        routes: routes
                    )
                    return (
                        interactor: interactor,
                        presenter: presenter
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.add.routerPath,
                use: controller.getAddSystemPermission
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddSystemPermission
            )
        }
    }
}
