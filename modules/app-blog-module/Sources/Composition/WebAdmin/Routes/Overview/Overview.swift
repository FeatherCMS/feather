import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

enum Overview {
    struct Router {
        struct Routes {
            let overview: WebRoute
            let posts: WebRoute
            let authors: WebRoute
            let tags: WebRoute
            let settings: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.overview = root
                self.posts = root.appending(pathComponent: "posts")
                self.authors = root.appending(pathComponent: "authors")
                self.tags = root.appending(pathComponent: "tags")
                self.settings = root.appending(pathComponent: "settings")
                self.breadcrumb = breadcrumb
            }
        }

        let controller: any Controller.Interface
        let routes: Routes

        init(renderingEngine: any RenderingEngine, routes: Routes) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(routes.overview.routerPath, use: controller.getOverview)
        }
    }
}
