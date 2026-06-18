import Hummingbird

struct AdminGetAuthProfile {
    let controller: any AdminGetAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthProfileDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAuthProfileDefaultInteractor(),
                    presenter: AdminGetAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
