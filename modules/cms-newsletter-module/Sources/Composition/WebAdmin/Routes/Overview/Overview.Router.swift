import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    struct Router {
        struct Routes: Sendable {
            let admin: WebRoute
            let overview: WebRoute
            let campaigns: WebRoute

            init(admin: WebRoute, root: WebRoute) {
                self.admin = admin
                self.overview = root
                self.campaigns = root.appending(pathComponent: "campaigns")
            }
        }

        let controller: any Controller.Interface
        let routes: Routes

        init(renderingEngine: any RenderingEngine, routes: Routes) {
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
            router.get(routes.overview.routerPath, use: controller.getOverview)
        }
    }
}
