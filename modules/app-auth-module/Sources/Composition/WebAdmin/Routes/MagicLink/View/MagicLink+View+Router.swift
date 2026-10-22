import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

extension MagicLink.View {
    struct Router {
        let routes: MagicLink.Router.Routes
        let controller: any MagicLink.View.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: MagicLink.Router.Routes
        ) {
            self.routes = routes
            self.controller = MagicLink.View.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: MagicLink.View.Interactor.Default(
                            repository: MagicLink.View.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: MagicLink.View.Presenter.Default(
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
            controller.route(on: router, routes: routes)
        }
    }
}
