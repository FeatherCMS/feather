import FeatherWebAdmin
import Hummingbird
import RedirectModule
import RedirectApplication

extension RedirectModule.Rule.Add {
    struct Router {
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
            router.get(routes.add.routerPath, use: controller.getAddRedirectRule)
            router.post(routes.add.routerPath, use: controller.postAddRedirectRule)
        }
    }
}
