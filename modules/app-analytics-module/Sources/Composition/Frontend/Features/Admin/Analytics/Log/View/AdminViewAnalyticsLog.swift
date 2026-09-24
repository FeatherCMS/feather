import FeatherAdmin

struct AdminViewAnalyticsLog {
    let controller: any AdminViewAnalyticsLogController

    init(apiBuilder: AnalyticsAPIBuilder, renderingEngine: any RenderingEngine)
    {
        self.controller = AdminViewAnalyticsLogDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAnalyticsLogDefaultInteractor(
                        repository: AdminViewAnalyticsLogOpenAPIRepository(
                            api: apiBuilder.makeAnalyticsAdmin(context)
                        )
                    ),
                    presenter: AdminViewAnalyticsLogDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
