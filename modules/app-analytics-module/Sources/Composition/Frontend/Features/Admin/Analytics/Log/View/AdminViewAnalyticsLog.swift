import FeatherAdmin

struct AdminViewAnalyticsLog {
    let controller: any AdminViewAnalyticsLogController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAnalyticsLogDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAnalyticsLogDefaultInteractor(
                        repository: AdminViewAnalyticsLogOpenAPIRepository(
                            api: AnalyticsAdminAPIClient(
                                apiBaseURL: AppEnvironmentStore.current
                                    .apiBaseURL,
                                sessionToken: context.sessionToken
                            )
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
