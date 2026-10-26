import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    struct Router {
        struct Routes: Sendable {
            let root: WebRoute
            let pages: WebRoute
            let menus: WebRoute
            let settings: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
        }

        let renderingEngine: any RenderingEngine
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let controller = Controller.Default(
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
            router.get(routes.root.routerPath, use: controller.getOverview)
        }
    }
}
