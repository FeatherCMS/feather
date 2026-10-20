import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission {
    enum Remove {}
}

extension Permission.Remove {
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
                routes: routes,
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
            router.post(
                routes.remove.routerPath,
                use: controller.postRemoveSystemPermissions
            )
        }
    }
}
