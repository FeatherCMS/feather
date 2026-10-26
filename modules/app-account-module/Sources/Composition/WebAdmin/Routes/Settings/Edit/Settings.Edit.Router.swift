import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: Settings.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Settings.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                ),
                                targetUserID: context.parameters.get(
                                    "userId",
                                    as: String.self
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
                routes.settings.routerPath,
                use: controller.getEdit
            )
            router.post(
                routes.settings.routerPath,
                use: controller.postEdit
            )
            router.get(
                routes.userSettingsPattern.routerPath,
                use: controller.getEdit
            )
            router.post(
                routes.userSettingsPattern.routerPath,
                use: controller.postEdit
            )
        }
    }
}
