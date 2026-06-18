import Hummingbird

struct AdminGetAnalyticsHome {
    let controller: any AdminGetAnalyticsHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAnalyticsHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAnalyticsHomeDefaultInteractor(),
                    presenter: AdminGetAnalyticsHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
