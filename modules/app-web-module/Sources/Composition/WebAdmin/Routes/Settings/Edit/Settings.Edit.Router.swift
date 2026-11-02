import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Settings.Edit {
    struct Router {
        private let controller: any Controller.Interface
        private let routes: Settings.Router.Routes
        private let environment: AppEnvironment

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Settings.Router.Routes
        ) {
            self.routes = routes
            self.environment = environment
            controller = Controller.Default(
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
                            renderEngine: renderingEngine
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Settings.HomePageLookup.Router(
                environment: environment,
                path: routes.homePageLookup
            ).route(on: router)
            router.get(routes.edit.routerPath, use: controller.getEditSettings)
            router.post(
                routes.edit.routerPath,
                use: controller.postEditSettings
            )
        }
    }
}
