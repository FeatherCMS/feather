import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Remove {
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
            router.post(
                routes.removeDetails.routerPath,
                use: controller.postRemoveRedirectRule
            )
            router.post(
                routes.remove.routerPath,
                use: controller.postRemoveRedirectRules
            )
        }
    }
}
