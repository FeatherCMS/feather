import FeatherAdmin
import Hummingbird

struct AdminListAnalyticsLog {
    let controller: any AdminListAnalyticsLogController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListAnalyticsLogDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAnalyticsLogDefaultInteractor(
                        repository: AdminListAnalyticsLogOpenAPIRepository(
                            api: AnalyticsAdminAPIClient(
                                apiBaseURL: AppEnvironmentStore.current
                                    .apiBaseURL,
                                sessionToken: context.sessionToken
                            )
                        )
                    ),
                    presenter: AdminListAnalyticsLogDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
