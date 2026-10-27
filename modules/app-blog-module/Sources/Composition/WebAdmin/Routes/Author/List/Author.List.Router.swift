import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule
import WebModuleWebAdmin

extension Author.List {
    struct Router {
        let controller: any Controller.Interface
        let routes: Author.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Author.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildViewRepository: { context in
                    Author.View.Repository.OpenAPI(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                },
                buildStatusRepository: { context in
                    WebModule.Metadata.Status.Repository.OpenAPI(
                        api: WebModuleWebAdmin.API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                },
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
            router.get(routes.authors.routerPath, use: controller.get)
            router.post(
                routes.authorStatusRoute.routerPath,
                use: controller.postStatusPath
            )
        }
    }
}
