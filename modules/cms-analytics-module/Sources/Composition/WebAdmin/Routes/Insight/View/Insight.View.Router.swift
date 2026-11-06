import AnalyticsAdminAPI
import AnalyticsModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Insight.View {
    struct Router {
        let source: Model.Source
        let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            source: Model.Source,
            renderingEngine: any RenderingEngine
        ) {
            self.source = source
            self.controller = Controller.Default(
                source: source,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            switch source {
            case .api:
                router.get(
                    AnalyticsWebAdmin.Router.Routes.api.routerPath,
                    use: controller.getInsights
                )
            case .web:
                router.get(
                    AnalyticsWebAdmin.Router.Routes.web.routerPath,
                    use: controller.getInsights
                )
            }
        }
    }
}
