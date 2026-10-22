import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Edit {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form {}
    struct Router {
        let controller: any Profile.Edit.Controller.Interface
        let routes: Profile.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Profile.Router.Routes
        ) {
            self.routes = routes
            self.controller = Profile.Edit.Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Profile.Edit.Interactor.Default(
                            profileRepository:
                                Profile.Edit.Repository.OpenAPI(
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
                        presenter: Profile.Edit.Presenter.Default(
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
            let path = routes.profileEdit.routerPath
            router.get(path, use: controller.getEditProfile)
            router.post(path, use: controller.postEditProfile)
        }
    }
}
