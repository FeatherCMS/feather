import FeatherWebAdmin
import Hummingbird
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.List {
    struct Router {
        static let pageSize = 20

        let controller: any Controller.Interface
        let routes: RedirectModule.Rule.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: RedirectModule.Rule.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
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
            router.get(routes.list.routerPath, use: controller.getRedirectRules)
        }
    }
}
