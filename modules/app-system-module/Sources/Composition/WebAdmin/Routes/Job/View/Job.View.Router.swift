import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule



extension Job.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: Job.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Job.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
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
                routes.details.routerPath,
                use: controller.getSystemJob
            )
        }
    }
}
