import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

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
                            environment: environment,
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
                    return WebAdminRuntime(
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
