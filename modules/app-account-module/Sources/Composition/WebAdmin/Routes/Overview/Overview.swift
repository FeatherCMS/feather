import FeatherWebAdmin
import Hummingbird

enum Overview {}

extension Overview {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form {}
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
