import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

enum Overview {
    struct Router {
        struct Routes {
            let admin: WebRoute
            let overview: WebRoute
            let variables: WebRoute
            let permissions: WebRoute
            let jobs: WebRoute

            init(admin: WebRoute, root: WebRoute) {
                self.admin = admin
                self.overview = root
                self.variables = root.appending(pathComponent: "variables")
                self.permissions = root.appending(pathComponent: "permissions")
                self.jobs = root.appending(pathComponent: "jobs")
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
            router.get(
                routes.overview.routerPath,
                use: controller.getOverview
            )
        }
    }
}
