import Hummingbird

struct AdminGetMediaHome {
    let controller: any AdminGetMediaHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaHomeDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaHomeDefaultInteractor(),
                    presenter: AdminGetMediaHomeDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
