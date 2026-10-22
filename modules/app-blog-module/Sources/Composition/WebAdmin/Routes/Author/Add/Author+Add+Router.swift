import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Author.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: BlogWebAdmin.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: BlogWebAdmin.Router.Routes = .standard
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                environment: environment,
                routes: routes,
                buildRuntime: { request, context in
                    (
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            let path = routes.authorAdd()
            router.get(path, use: controller.get)
            router.post(path, use: controller.post)
        }
    }
}
