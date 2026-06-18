import Hummingbird

struct AdminGetAnalyticsLog {
    let controller: any AdminGetAnalyticsLogController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAnalyticsLogDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAnalyticsLogDefaultInteractor(
                        repository: AdminGetAnalyticsLogOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetAnalyticsLogDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
