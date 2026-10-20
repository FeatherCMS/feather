import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Identity.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Identity.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    let api = API.Client(
                        apiBaseURL: environment.apiBaseURL,
                        requestContext: context
                    )
                    return (
                        interactor: Interactor.Default(
                            repository:
                                Repository.OpenAPI(
                                    api: api
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
                use: controller.postRemoveUserIdentities
            )
            router.post(
                routes.removeDetails.routerPath,
                use: controller.postRemoveUserIdentity
            )
        }

    }
}
