import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Job {
    enum List {}
}

extension WebAdmin.System.Job.List {
    struct Router {
        static let pageSize = 20

        let controller: any Controller.Interface
        let routes: WebAdmin.System.Job.Router.Routes

        init(
            apiBuilder: SystemAPIBuilder,
            renderingEngine: any RenderingEngine,
            routes: WebAdmin.System.Job.Router.Routes
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
                routes.list.routerPath,
                use: controller.getSystemJobs
            )
        }
    }
}
