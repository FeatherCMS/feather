import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminViewAnalyticsInsights {
    let source: AdminAnalyticsInsightsPage.Source
    let controller: any AdminViewAnalyticsInsightsController

    init(
        apiBuilder: AnalyticsAdminAPIBuilder,
        source: AdminAnalyticsInsightsPage.Source,
        renderingEngine: any RenderingEngine
    ) {
        self.source = source
        self.controller = AdminViewAnalyticsInsightsDefaultController(
            source: source,
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminViewAnalyticsInsightsDefaultInteractor(
                        repository: AdminViewAnalyticsInsightsOpenAPIRepository(
                            api: apiBuilder.makeAnalyticsAdmin(context)
                        )
                    ),
                    presenter: AdminViewAnalyticsInsightsDefaultPresenter(
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
                Router.Routes.api,
                use: controller.getInsights
            )
        case .web:
            router.get(
                Router.Routes.web,
                use: controller.getInsights
            )
        }
    }
}
