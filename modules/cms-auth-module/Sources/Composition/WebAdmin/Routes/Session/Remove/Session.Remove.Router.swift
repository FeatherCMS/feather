import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserWebAdmin

extension Session.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Session.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Session.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    let api = API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    let userAPI = UserWebAdmin.API.Client(
                        environment: environment,
                        requestContext: context
                    )
                    return WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository:
                                Repository.OpenAPI(
                                    api: api,
                                    userAPI: userAPI
                                )
                        ),
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
            router.post(
                routes.remove.routerPath,
                use: controller.postRemoveAuthSession
            )
        }
    }
}
