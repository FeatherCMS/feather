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

extension Overview {
    enum View {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
}

extension Overview.View {
    struct Router {
        struct Routes: Sendable {
            let root: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let assets: WebRoute
            let variants: WebRoute
        }

        let controller: any Overview.View.Controller.Interface

        init(
            routes: Routes,
            renderingEngine: any RenderingEngine
        ) {
            self.routes = routes
            self.controller = Overview.View.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Overview.View.Interactor.Default(),
                        presenter: Overview.View.Presenter.Default(
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
