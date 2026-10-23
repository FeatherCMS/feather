import FeatherWebAdmin

struct AdminViewAnalyticsOverview {
    let controller: any AdminViewAnalyticsOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAnalyticsOverviewDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
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
