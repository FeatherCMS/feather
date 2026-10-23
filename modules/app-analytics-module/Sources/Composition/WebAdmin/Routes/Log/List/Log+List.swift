import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.List {
    struct Router {
        let controller: any Controller.Interface

        init(
            apiBuilder: AnalyticsAdminAPIBuilder,
            renderingEngine: any RenderingEngine
        ) {
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeAnalyticsAdmin(context)
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(
                AnalyticsWebAdmin.Router.Routes.logs,
                use: controller.getLogs
            )
        }
    }
}
