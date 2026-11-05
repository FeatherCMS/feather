import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository:
                                Repository.OpenAPI(
                                    api: API.Client(
                                        environment: environment,
                                        requestContext: context
                                    )
                                )
                        ),
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
            router.post(
                routes.invitationRemoveBulk.routerPath,
                use: controller.postRemove
            )
        }
    }
}
