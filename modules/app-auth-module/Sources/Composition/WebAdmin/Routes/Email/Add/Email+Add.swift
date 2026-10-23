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



extension Email.Add {
    struct Router {
        let controller: any Email.Add.Controller.Interface
        let routes: Email.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Email.Router.Routes
        ) {
            self.routes = routes
            self.controller = Email.Add.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Email.Add.Interactor.Default(
                            repository: Email.Add.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                ),
                                userAPI: UserWebAdmin.API.Client(
                                    apiBaseURL: environment.apiBaseURL,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Email.Add.Presenter.Default(
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
            router.get(routes.add.routerPath, use: controller.getAddAuthEmail)
            router.post(routes.add.routerPath, use: controller.postAddAuthEmail)
        }
    }
}
