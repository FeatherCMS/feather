import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension AuthorLink.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: AuthorLink.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: AuthorLink.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            let path = routes.authorLinkAddRoute.routerPath
            router.get(path, use: controller.get)
            router.post(path, use: controller.post)
        }
    }
}
