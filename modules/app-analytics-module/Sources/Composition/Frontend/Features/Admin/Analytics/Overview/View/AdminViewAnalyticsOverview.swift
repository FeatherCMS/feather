import FeatherAdmin

struct AdminViewAnalyticsOverview {
    let controller: any AdminViewAnalyticsOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAnalyticsOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAnalyticsOverviewDefaultInteractor(),
                    presenter: AdminViewAnalyticsOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
