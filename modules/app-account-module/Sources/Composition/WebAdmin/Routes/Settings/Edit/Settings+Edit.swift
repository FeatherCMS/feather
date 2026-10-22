import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    enum Controller {}
    enum Interactor {}
    enum Presenter {}
    enum Repository {}
    enum Form {}
    struct Router {
        let controller: any Settings.Edit.Controller.Interface
        let routes: Settings.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Settings.Router.Routes
        ) {
            self.routes = routes
            self.controller = Settings.Edit.Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
                        interactor: Settings.Edit.Interactor.Default(
                            repository: Settings.Edit.Repository.OpenAPI(
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
                        presenter: Settings.Edit.Presenter.Default(
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
                use: controller.getEditSettings
            )
            router.post(
                routes.settings.routerPath,
                use: controller.postEditSettings
            )
            router.get(
                routes.userSettingsPattern.routerPath,
                use: controller.getEditSettings
            )
            router.post(
                routes.userSettingsPattern.routerPath,
                use: controller.postEditSettings
            )
        }
    }
}
