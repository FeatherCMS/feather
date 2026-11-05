import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Contact.Overview {
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(routes.root.routerPath, use: controller.getOverview)
        }

        struct Routes: Sendable {
            let root: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let forms: WebRoute
            let fields: WebRoute
            let submissions: WebRoute

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                forms: WebRoute,
                fields: WebRoute,
                submissions: WebRoute
            ) {
                self.root = root
                self.breadcrumb = breadcrumb
                self.forms = forms
                self.fields = fields
                self.submissions = submissions
            }
        }
    }
}
