import FeatherAdmin
import Hummingbird
import SystemModule

extension Job {
    enum View {}
}

extension Job.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: Job.Router.Routes

        init(
            apiBuilder: API.Builder,
            renderingEngine: any RenderingEngine,
            routes: Job.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeSystemAdmin(context)
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
