import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: Role.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Role.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
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
            router.get(routes.edit.routerPath, use: controller.getEditUserRole)
            router.post(
                routes.edit.routerPath,
                use: controller.postEditUserRole
            )
        }
    }
}
