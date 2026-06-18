import Hummingbird

struct AdminRemoveWebMenuItem {
    let controller: any AdminRemoveWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuItemDefaultInteractor(
                        repository: AdminRemoveWebMenuItemOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
