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
            apiBuilder: AnalyticsAdminAPIBuilder,
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
                                api: apiBuilder.makeAnalyticsAdmin(context)
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
                    AnalyticsWebAdmin.Router.Routes.api,
                    use: controller.getInsights
                )
            case .web:
                router.get(
                    AnalyticsWebAdmin.Router.Routes.web,
                    use: controller.getInsights
                )
            }
        }
    }
}
