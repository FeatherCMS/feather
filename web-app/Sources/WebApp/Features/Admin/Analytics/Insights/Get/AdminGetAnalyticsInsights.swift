import Hummingbird

struct AdminGetAnalyticsInsights {
    let source: AdminAnalyticsInsightsPage.Source
    let controller: any AdminGetAnalyticsInsightsController

    init(
        source: AdminAnalyticsInsightsPage.Source,
        renderingEngine: any RenderingEngine
    ) {
        self.source = source
        self.controller = AdminGetAnalyticsInsightsDefaultController(
            source: source,
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAnalyticsInsightsDefaultInteractor(
                        repository: AdminGetAnalyticsInsightsOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetAnalyticsInsightsDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        switch source {
        case .api:
            router.get(
                "/admin/analytics/api/",
                use: controller.getInsights
            )
        case .web:
            router.get(
                "/admin/analytics/web/",
                use: controller.getInsights
            )
        }
    }
}
