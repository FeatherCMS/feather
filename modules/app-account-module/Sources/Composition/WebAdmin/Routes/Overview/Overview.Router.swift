import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    struct Router {
        let controller: any Controller.Interface
        let routes: Routes

        init(
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(),
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
            router.get(routes.account.routerPath, use: controller.getOverview)
        }
    }
}
