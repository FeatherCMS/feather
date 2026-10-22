import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Overview {
    struct Router {
        struct Routes {
            let path: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let email: Email.Router.Routes
            let credential: Credential.Router.Routes
            let magicLink: MagicLink.Router.Routes
            let accessControl: RolePermission.Router.Routes
        }

        let routes: Routes
        let controller: any Overview.Controller.Interface

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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(routes.path.routerPath, use: controller.getOverview)
        }
    }
}
