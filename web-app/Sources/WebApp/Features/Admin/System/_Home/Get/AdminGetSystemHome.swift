import Hummingbird

struct AdminGetSystemHome {
    let controller: any AdminGetSystemHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetSystemHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetSystemHomeDefaultInteractor(),
                    presenter: AdminGetSystemHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
