import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectModule

enum Overview {
    struct Router {
        private let controller: any Controller.Interface
        private let path: WebRoute

        init(
            renderingEngine: any RenderingEngine,
            path: WebRoute,
            ruleRoutes: Rule.Router.Routes
        ) {
            self.path = path
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            ruleRoutes: ruleRoutes
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(path.routerPath, use: controller.getOverview)
        }
    }
}
