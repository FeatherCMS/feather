import FeatherAdmin

struct AdminListAnalyticsLog {
    let controller: any AdminListAnalyticsLogController

    init(apiBuilder: AnalyticsAPIBuilder, renderingEngine: any RenderingEngine) {
        self.controller = AdminListAnalyticsLogDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAnalyticsLogDefaultInteractor(
                        repository: AdminListAnalyticsLogOpenAPIRepository(
                            api: apiBuilder.makeAnalyticsAdmin(context)
                        )
                    ),
                    presenter: AdminListAnalyticsLogDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
