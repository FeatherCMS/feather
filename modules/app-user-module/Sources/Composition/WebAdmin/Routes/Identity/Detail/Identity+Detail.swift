import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Detail {
    struct Router {
        let controller: any Controller.Interface
        let routes: Identity.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Identity.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    let userAPI = API.Client(
                        apiBaseURL: environment.apiBaseURL,
                        requestContext: context
                    )
                    return WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(api: userAPI),
                            roleRepository: Repository.Role.OpenAPI(api: userAPI)
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
            router.get(routes.details.routerPath, use: controller.getUserIdentity)
        }
    }
}
