import Hummingbird

struct AdminRemoveWebMenu {
    let controller: any AdminRemoveWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveWebMenuDefaultInteractor(
                        repository: AdminRemoveWebMenuOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminRemoveWebMenuDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
