import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Overview.View {
    struct Router {
        struct Routes: Sendable {
            let root: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let assets: WebRoute
            let variants: WebRoute
        }

        let controller: any Controller.Interface

        init(
            routes: Routes,
            renderingEngine: any RenderingEngine
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.root.routerPath, use: controller.getOverview)
        }

        private let routes: Routes
    }
}
