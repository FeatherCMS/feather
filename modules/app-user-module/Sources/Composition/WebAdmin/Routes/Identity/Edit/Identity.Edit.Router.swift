import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Edit {
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
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            identityRepository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            ),
                            roleRepository: Repository.Role.OpenAPI(
                                api: API.Client(
                                    environment: environment,
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
                routes.edit.routerPath,
                use: controller.getEditUserIdentity
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditUserIdentity
            )
        }
    }
}
