import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Resend {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form { enum Input {} }
    struct Router {

        let controller: Invitation.Resend.Controller.Default
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            routes: Invitation.Router.Routes,
        ) {
            self.routes = routes
            self.controller = .init(
                routes: routes,
                buildRepository: { context in
                    Invitation.Resend.Repository.OpenAPI(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(
                routes.invitationResendPattern.routerPath,
                use: controller.resend
            )
        }
    }
}
