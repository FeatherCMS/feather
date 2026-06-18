import Hummingbird

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
