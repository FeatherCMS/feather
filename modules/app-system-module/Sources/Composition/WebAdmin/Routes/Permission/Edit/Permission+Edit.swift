import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission {
    enum Edit {}
}

extension Permission.Edit {
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
                routes.edit.routerPath,
                use: controller.getEditSystemPermission
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditSystemPermission
            )
        }
    }
}
