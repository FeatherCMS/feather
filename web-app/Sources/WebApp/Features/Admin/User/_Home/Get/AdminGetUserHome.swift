import Hummingbird

struct AdminGetUserHome {
    let controller: any AdminGetUserHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetUserHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetUserHomeDefaultInteractor(),
                    presenter: AdminGetUserHomeDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
