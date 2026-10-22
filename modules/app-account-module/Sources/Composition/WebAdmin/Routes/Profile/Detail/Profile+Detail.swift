import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Detail {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form { enum Input {} }
    struct Router {
        let controller: any Profile.Detail.Controller.Interface
        let routes: Profile.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Profile.Router.Routes
        ) {
            self.routes = routes
            self.controller = Profile.Detail.Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Profile.Detail.Interactor.Default(
                            accountProfileRepository:
                                Profile.Detail.Repository.OpenAPI(
                                    api: API.AppClient(
                                        environment: environment,
                                        requestContext: context
                                    ),
                                    mediaAPI: MediaAdminAPIClient(
                                        environment: environment,
                                        requestContext: context
                                    )
                                )
                        ),
                        presenter: Profile.Detail.Presenter.Default(
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
            router.get(
                routes.profile.routerPath,
                use: controller.getAccountProfile
            )
        }
    }
}
