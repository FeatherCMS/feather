import FeatherWebAdmin
import Hummingbird

extension Overview {
    struct Router {
        let controller: any Overview.Controller.Interface
        let routes: Routes

        init(
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.routes = routes
            self.controller = Overview.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Overview.Interactor.Default(),
                        presenter: Overview.Presenter.Default(
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
