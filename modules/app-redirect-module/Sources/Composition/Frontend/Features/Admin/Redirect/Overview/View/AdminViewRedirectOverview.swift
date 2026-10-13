import FeatherAdmin

struct AdminViewRedirectOverview {
    let controller: any AdminViewRedirectOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewRedirectOverviewDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewRedirectOverviewDefaultInteractor(),
                    presenter: AdminViewRedirectOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
