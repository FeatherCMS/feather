import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    struct Router {

        let controller: any Invitation.Add.Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Invitation.Add.Controller.Default(
                environment: environment,
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Invitation.Add.Interactor.Default(
                            repository: Invitation.Add.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Invitation.Add.Presenter.Default(
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
            let path = routes.invitationAdd.routerPath
            router.get(path, use: controller.getAdd)
            router.post(path, use: controller.postAdd)
        }
    }
}
