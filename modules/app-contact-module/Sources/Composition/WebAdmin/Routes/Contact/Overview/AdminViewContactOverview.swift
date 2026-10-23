import FeatherWebAdmin

struct AdminViewContactOverview {
    let controller: any AdminViewContactOverviewController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewContactOverviewDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminViewContactOverviewDefaultInteractor(),
                    presenter: AdminViewContactOverviewDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
