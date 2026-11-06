import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserWebAdmin

extension Invitation.Edit {
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
                roleRepository: { context in
                    Invitation.Form.Repository.Role.OpenAPI(
                        api: UserWebAdmin.API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                },
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
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
            let path = routes.invitationEditPattern.routerPath
            router.get(path, use: controller.getEdit)
            router.post(path, use: controller.postEdit)
        }
    }
}
