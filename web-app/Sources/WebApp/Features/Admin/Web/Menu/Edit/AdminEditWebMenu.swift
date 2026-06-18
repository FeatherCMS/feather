import Hummingbird

struct AdminEditWebMenu {
    let controller: any AdminEditWebMenuController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMenuDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuDefaultInteractor(
                        repository: AdminEditWebMenuOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditWebMenuDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
