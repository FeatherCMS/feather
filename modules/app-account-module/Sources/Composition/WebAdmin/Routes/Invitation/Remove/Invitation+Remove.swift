import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form { enum Input {} }
    struct Router {
        let controller: any Invitation.Remove.Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Invitation.Remove.Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Invitation.Remove.Interactor.Default(
                            repository:
                                Invitation.Remove.Repository.OpenAPI(
                                    api: API.Client(
                                        environment: environment,
                                        requestContext: context
                                    )
                                )
                        ),
                        presenter: Invitation.Remove.Presenter.Default(
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
                use: controller.postRemoveAccountInvitation
            )
        }
    }
}
