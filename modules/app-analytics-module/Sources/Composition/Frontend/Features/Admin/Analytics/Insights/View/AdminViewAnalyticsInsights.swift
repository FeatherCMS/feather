import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsInsights {
    let source: AdminAnalyticsInsightsPage.Source
    let controller: any AdminViewAnalyticsInsightsController

    init(
        apiBuilder: AnalyticsAPIBuilder,
        source: AdminAnalyticsInsightsPage.Source,
        renderingEngine: any RenderingEngine
    ) {
        self.source = source
        self.controller = AdminViewAnalyticsInsightsDefaultController(
            source: source,
            buildRuntime: { request, context in
                (
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
                AnalyticsAdminRoutes.api,
                use: controller.getInsights
            )
        case .web:
            router.get(
                AnalyticsAdminRoutes.web,
                use: controller.getInsights
            )
        }
    }
}
