import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Add {
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
                    (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    apiBaseURL: environment.apiBaseURL,
                                    requestContext: context
                                )
                            ),
                            roleRepository:
                                Repository.Role.OpenAPI(
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
                use: controller.getAddUserIdentity
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddUserIdentity
            )
        }

    }
}
