import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule
import MediaWebAdmin

extension Profile.Detail {
    struct Router {
        let controller: any Controller.Interface
        let routes: Profile.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Profile.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            profileRepository:
                                Repository.OpenAPI(
                                    api: API.Client(
                                        environment: environment,
                                        requestContext: context
                                    ),
                                    mediaRepository: MediaModule.Asset.File.View
                                        .Repository.OpenAPI(
                                            api: MediaWebAdmin.API.Client(
                                                environment: environment,
                                                requestContext: context
                                            )
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
            router.get(
                routes.profile.routerPath,
                use: controller.getDetail
            )
        }
    }
}
