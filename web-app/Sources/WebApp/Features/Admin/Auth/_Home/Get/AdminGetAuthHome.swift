import Hummingbird

struct AdminGetAuthHome {
    let controller: any AdminGetAuthHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAuthHomeDefaultInteractor(),
                    presenter: AdminGetAuthHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
