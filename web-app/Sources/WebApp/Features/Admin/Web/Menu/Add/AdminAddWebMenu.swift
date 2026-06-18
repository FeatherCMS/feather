import Hummingbird

struct AdminAddWebMenu {
    let controller: any AdminAddWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuDefaultInteractor(
                        repository: AdminAddWebMenuOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddWebMenuDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
