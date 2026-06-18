import Hummingbird

struct AdminGetRedirectHome {
    let controller: any AdminGetRedirectHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetRedirectHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetRedirectHomeDefaultInteractor(),
                    presenter: AdminGetRedirectHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
