import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form {}
    struct Router {
        let controller: any Invitation.Edit.Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Invitation.Edit.Controller.Default(
                environment: environment,
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Invitation.Edit.Interactor.Default(
                            repository: Invitation.Edit.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Invitation.Edit.Presenter.Default(
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
            router.get(path, use: controller.getEditAccountInvitation)
            router.post(path, use: controller.postEditAccountInvitation)
        }
    }
}
