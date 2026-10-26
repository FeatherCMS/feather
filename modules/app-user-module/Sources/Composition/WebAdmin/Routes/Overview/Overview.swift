import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

enum Overview {
    struct Router {
        struct Routes {
            let admin: WebRoute
            let overview: WebRoute
            let identities: WebRoute
            let roles: WebRoute

            init(admin: WebRoute, root: WebRoute) {
                self.admin = admin
                self.overview = root
                self.identities = root.appending(pathComponent: "identities")
                self.roles = root.appending(pathComponent: "roles")
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
