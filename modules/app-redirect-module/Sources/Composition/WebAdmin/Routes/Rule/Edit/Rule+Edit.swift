import FeatherWebAdmin
import Hummingbird
import RedirectModule

extension RedirectModule.Rule.Edit {
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
            router.get(routes.edit.routerPath, use: controller.getEditRedirectRule)
            router.post(routes.edit.routerPath, use: controller.postEditRedirectRule)
        }
    }
